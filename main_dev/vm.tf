resource "azurerm_virtual_network" "main" {
  name                = "${var.stage}_network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.stage}_internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
  # service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.stage}_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "configuration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "winserver" {
  name                  = "${var.stage}_vm_ad"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B2s"
  # vm_size               = "Standard_B2ms"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  # copy properties in createion pages on browser
  # イメージ選択ページの「使用状況情報とサポート」から転記する
  storage_image_reference {
    publisher = "microsoftwindowsserver"
    offer     = "windowsserver"
    sku       = "2022-datacenter-azure-edition-hotpatch"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.stage}-main"
    admin_username = var.vm_admin
    admin_password = var.vm_password
  }
  os_profile_windows_config {
    provision_vm_agent         = false
    enable_automatic_upgrades  = false
    # timezone                   = "UTC"
    timezone                   = "Tokyo Standard Time"
    # winrm                      = {
    #   protocol = "HTTPS"
    #   certificate_url = ""
    # }
    # additional_unattend_config = {}
  }
  tags = {
    environment = var.stage
  }
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes    = ["10.0.4.0/26"]
}

resource "azurerm_public_ip" "bastion_ip" {
  name                = "bastion_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "${var.stage}_bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Developer"
  ip_configuration {
    name                 = "configuration_bastion"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
  tags = {
    environment = var.stage
  }
}
