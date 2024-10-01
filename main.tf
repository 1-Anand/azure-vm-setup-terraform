resource "azurerm_resource_group" "rgs" {
  for_each = var.rglist
  name     = each.value.name
  location = each.value.location
}

resource "azurerm_virtual_network" "vnets" {
  depends_on = [ azurerm_resource_group.rgs ]
  for_each            = var.vnetlist
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space


}

resource "azurerm_subnet" "subnets" {
  depends_on = [ azurerm_virtual_network.vnets ]
  for_each             = var.subnetlist
  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
  address_prefixes     = each.value.address_prefixes
}






resource "azurerm_network_interface" "nic1" {
  depends_on = [ azurerm_subnet.subnets ]
  for_each            = var.niclist
  name                = "${each.value.name}-nic"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[each.value.subnet_key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pips[each.value.pip_key].id
  }
}




resource "azurerm_linux_virtual_machine" "vm1" {
  depends_on = [ azurerm_network_interface.nic1 ]
  for_each                        = var.vmlist
  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = each.value.disable_password_authentication

  network_interface_ids = [
    azurerm_network_interface.nic1[each.value.network_interface_key].id
  ]

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }
}

resource "azurerm_network_security_group" "nsgs" {
  for_each = var.nsglist
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = each.value.security_rule_name
    priority                   = each.value.priority
    direction                  = each.value.direction
    access                     = each.value.access
    protocol                   = each.value.protocol
    source_port_range          = each.value.source_port_range
    destination_port_ranges    = each.value.destination_port_ranges
    source_address_prefix      = each.value.source_address_prefix
    destination_address_prefix = each.value.destination_address_prefix
  }

}

resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  depends_on = [
    azurerm_network_interface.nic1,
    azurerm_network_security_group.nsgs
  ]
  
  for_each = var.niclist

  network_interface_id      = azurerm_network_interface.nic1[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.value.nsg_key].id
}


resource "azurerm_public_ip" "pips" {
  for_each            = var.piplist
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
}






