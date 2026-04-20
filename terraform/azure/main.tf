locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      Owner       = var.owner
      CostCenter  = var.cost_center
    },
    var.extra_tags
  )

  app_source_prefixes = coalesce(var.allowed_app_source_addresses, var.allowed_source_addresses)
}

resource "azurerm_resource_group" "lab" {
  name     = "${var.project_name}-rg"
  location = var.location

  tags = local.common_tags
}

resource "azurerm_virtual_network" "lab" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.42.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  tags = local.common_tags
}

resource "azurerm_subnet" "lab" {
  name                 = "${var.project_name}-subnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.42.1.0/24"]
}

resource "azurerm_public_ip" "lab" {
  name                = "${var.project_name}-pip"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Basic"

  tags = local.common_tags
}

resource "azurerm_network_security_group" "lab" {
  name                = "${var.project_name}-nsg"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.allowed_source_addresses
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "App8000"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8000"
    source_address_prefixes    = local.app_source_prefixes
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

resource "azurerm_network_interface" "lab" {
  name                = "${var.project_name}-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab.id
  }

  tags = local.common_tags
}

resource "azurerm_network_interface_security_group_association" "lab" {
  network_interface_id      = azurerm_network_interface.lab.id
  network_security_group_id = azurerm_network_security_group.lab.id
}

resource "random_id" "disk" {
  byte_length = 4
}

resource "azurerm_linux_virtual_machine" "lab" {
  name                = "${var.project_name}-vm"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.lab.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${var.project_name}-os-${random_id.disk.hex}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  disable_password_authentication = true

  tags = local.common_tags
}
