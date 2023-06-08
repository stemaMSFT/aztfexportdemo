resource "azurerm_resource_group" "res-0" {
  location = "westus2"
  name     = "myResourceGroup"
}
resource "azurerm_ssh_public_key" "res-1" {
  location            = "westus2"
  name                = "myVM_key"
  public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCoJbVugghKcAy5K0PUs2c+o9czcK8m2IdpczlvYDdgyuIqJ5u3Cgmk7HRMpoJpdI79hvGDXgagaHrfSrAR/hXrxUoAbT7K7RJ1ggPrWNDdbRUnntPVwadyzCzVGilJx5oMgIhggi25yVl+RlMtTskmoreVxC2UB+bU1f1ZnOOtn/wFUGV4h0DLyiv2bYWrnuE8HIif9OPdFMi+iu8MMQgUN1GZcqubVWlcxqqhXUOL3pfiA0SZylkJlfpifU0mKPz926Q711w67bsuir356GOOU8PlS+4jeDajhFk/yH5zgMKyAODcdOfbMnRXLX8kvqScp8svMmZLw35odjJDsn8XWJpNZTGNm+ozAu+Tj5bl/ZBvNUcbP4a/U1Tf3Da/h4seeoO66WVQksGKI0/D+O/WBTYLsCEsA2sN9o31o+jMe8CKj4V47fnA7e/P6YVpvElZnokcU/ynw2wuZ16tyCh+pe15B6uDvWONI0wFr1PF7LgcLjn9QfvjjpgBJErSIfk= generated-by-azure"
  resource_group_name = "myResourceGroup"
  tags = {
    environment = "Production"
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_linux_virtual_machine" "res-2" {
  admin_username        = "azureuser"
  location              = "westus2"
  name                  = "myVM"
  network_interface_ids = ["/subscriptions/0000/resourceGroups/myResourceGroup/providers/Microsoft.Network/networkInterfaces/myvm669_z1"]
  resource_group_name   = "myResourceGroup"
  secure_boot_enabled   = true
  size                  = "Standard_D4s_v3"
  tags = {
    environment = "Production"
  }
  vtpm_enabled = true
  zone         = "1"
  admin_ssh_key {
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCoJbVugghKcAy5K0PUs2c+o9czcK8m2IdpczlvYDdgyuIqJ5u3Cgmk7HRMpoJpdI79hvGDXgagaHrfSrAR/hXrxUoAbT7K7RJ1ggPrWNDdbRUnntPVwadyzCzVGilJx5oMgIhggi25yVl+RlMtTskmoreVxC2UB+bU1f1ZnOOtn/wFUGV4h0DLyiv2bYWrnuE8HIif9OPdFMi+iu8MMQgUN1GZcqubVWlcxqqhXUOL3pfiA0SZylkJlfpifU0mKPz926Q711w67bsuir356GOOU8PlS+4jeDajhFk/yH5zgMKyAODcdOfbMnRXLX8kvqScp8svMmZLw35odjJDsn8XWJpNZTGNm+ozAu+Tj5bl/ZBvNUcbP4a/U1Tf3Da/h4seeoO66WVQksGKI0/D+O/WBTYLsCEsA2sN9o31o+jMe8CKj4V47fnA7e/P6YVpvElZnokcU/ynw2wuZ16tyCh+pe15B6uDvWONI0wFr1PF7LgcLjn9QfvjjpgBJErSIfk= generated-by-azure"
    username   = "azureuser"
  }
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-minimal-focal"
    publisher = "canonical"
    sku       = "minimal-20_04-lts-gen2"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-3,
  ]
}
resource "azurerm_network_interface" "res-3" {
  enable_accelerated_networking = true
  location                      = "westus2"
  name                          = "myvm669_z1"
  resource_group_name           = "myResourceGroup"
  tags = {
    environment = "Production"
  }
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "/subscriptions/0000/resourceGroups/myResourceGroup/providers/Microsoft.Network/publicIPAddresses/myVM-ip"
    subnet_id                     = "/subscriptions/0000/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVM-vnet/subnets/default"
  }
  depends_on = [
    azurerm_public_ip.res-7,
    azurerm_subnet.res-9,
  ]
}
resource "azurerm_network_interface_security_group_association" "res-4" {
  network_interface_id      = "/subscriptions/0000/resourceGroups/myResourceGroup/providers/Microsoft.Network/networkInterfaces/myvm669_z1"
  network_security_group_id = "/subscriptions/0000/resourceGroups/myResourceGroup/providers/Microsoft.Network/networkSecurityGroups/myVM-nsg"
  depends_on = [
    azurerm_network_interface.res-3,
    azurerm_network_security_group.res-5,
  ]
}
resource "azurerm_network_security_group" "res-5" {
  location            = "westus2"
  name                = "myVM-nsg"
  resource_group_name = "myResourceGroup"
  tags = {
    environment = "Production"
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_network_security_rule" "res-6" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = "myVM-nsg"
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = "myResourceGroup"
  source_address_prefix       = "10.0.0.0/24"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-5,
  ]
}
resource "azurerm_public_ip" "res-7" {
  allocation_method   = "Static"
  location            = "westus2"
  name                = "myVM-ip"
  resource_group_name = "myResourceGroup"
  sku                 = "Standard"
  tags = {
    environment = "Production"
  }
  zones = ["1"]
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_virtual_network" "res-8" {
  address_space       = ["10.2.0.0/16"]
  location            = "westus2"
  name                = "myVM-vnet"
  resource_group_name = "myResourceGroup"
  tags = {
    environment = "Production"
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_subnet" "res-9" {
  address_prefixes     = ["10.2.0.0/24"]
  name                 = "default"
  resource_group_name  = "myResourceGroup"
  virtual_network_name = "myVM-vnet"
  depends_on = [
    azurerm_virtual_network.res-8,
  ]
}
