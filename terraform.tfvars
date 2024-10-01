
rglist = {
  bhushan_rg1 = {
    name     = "bhushan-rg-01"
    location = "Central India"
  }
  bhushan_rg2 = {
    name     = "bhushan-rg-02"
    location = "Central India"
  }
}

vnetlist = {
  bhushan_vnet1 = {
    name                = "bhushan-vnet-01"
    location            = "centralindia"
    resource_group_name = "bhushan-rg-01"
    address_space       = ["10.0.0.0/16"]
  }
}

subnetlist = {
  bhushan_subnet1 = {
    name                 = "bhushan-subnet-01"
    virtual_network_name = "bhushan-vnet-01"
    resource_group_name  = "bhushan-rg-01"
    address_prefixes     = ["10.0.1.0/24"]
  }
}


piplist = {
  bhushan_pip1 = {
    name                = "bhushan-test-pip-01"
    resource_group_name = "bhushan-rg-01"
    location            = "centralindia"
    allocation_method   = "Static"
  }
}



niclist = {
  bhushan_nic1 = {
    name                = "bhushan-nic-01"
    resource_group_name = "bhushan-rg-01"
    location            = "centralindia"
    subnet_key          = "bhushan_subnet1"
    nsg_key             = "nsg1"  # This associates NIC with the NSG
  }
}


vmlist = {
  bhushan_vm1 = {
    name                            = "bhushan-vm-01"
    location                        = "centralindia"
    resource_group_name             = "bhushan-rg-01"
    size                            = "Standard_DS1_v2"
    admin_username                  = "adminuser"
    admin_password                  = "Password!12345"
    disable_password_authentication = false

    network_interface_key = "bhushan_nic1"

    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }
}

nsglist = {
  nsg1 = {
    name                       = "bhushanWebsiteSecurityGroup"
    location                   = "Central India"
    resource_group_name         = "bhushan-rg-01"
    security_rule_name          = "allow-http-ssh"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_ranges     = ["80", "22"]
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    
  }
}

