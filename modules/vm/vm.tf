variable "mod_vm_name" {}
variable "mod_common_tags" {}
variable "mod_vm_count" {}
variable "mod_location" {}
variable "mod_resource_group_name" {}
variable "mod_subnet_id" {}
variable "mod_ssh_public_key" {}
variable "mod_zones" {}

resource "azurerm_public_ip" "publicipconnect" {
  count = var.mod_vm_count
  name                = "pip${var.mod_vm_name}${count.index + 1}"
  location            = "${var.mod_location}"
  resource_group_name = "${var.mod_resource_group_name}"
  allocation_method   = "Static"

  tags = var.mod_common_tags
}

resource "azurerm_network_interface" "connect" {
  count = var.mod_vm_count    
  name                = "nic${var.mod_vm_name}${count.index + 1}"
  location            = "${var.mod_location}"
  resource_group_name = "${var.mod_resource_group_name}"

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.mod_subnet_id
    # private_ip_address_allocation = "Static"
    private_ip_address_allocation = "Dynamic"    
    # private_ip_address            = "10.0.0.10"
    public_ip_address_id          = azurerm_public_ip.publicipconnect[count.index].id  
  }
tags = var.mod_common_tags  
}

resource "azurerm_managed_disk" "managed_disk" {
  count               = var.mod_vm_count 
  name                 = "data${var.mod_vm_name}${count.index + 1}-md"
  location            = "${var.mod_location}"
  zone                = "${var.mod_zones[(count.index+1)%length(var.mod_zones)]}"  
  resource_group_name = "${var.mod_resource_group_name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 64
}

resource "azurerm_linux_virtual_machine" "rhel8vm" {
  count               = var.mod_vm_count 
  name                = "${var.mod_vm_name}${count.index + 1}"
  location            = "${var.mod_location}"
  resource_group_name = "${var.mod_resource_group_name}"
  zone                = "${var.mod_zones[(count.index+1)%length(var.mod_zones)]}"
  size                = "Standard_B2s"
  admin_username      = "azureadmin"
  network_interface_ids = [
    azurerm_network_interface.connect[count.index].id
  ]
  disable_password_authentication = "true"
  # admin_password = "test4me!!"
  custom_data    = base64encode(data.template_file.rhel-cloud-init.rendered)
  admin_ssh_key {
    username   = "azureadmin"
    public_key = var.mod_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb = 64
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "86-gen2"
    version   = "latest"
  }
  
tags = var.mod_common_tags  
}

# Data template Bash bootstrapping file
data "template_file" "rhel-cloud-init" {
  template = file("scripts/customize_system.sh")
}




resource "azurerm_virtual_machine_data_disk_attachment" "vm_managed_disk_attachment" {
  count               = var.mod_vm_count 
  managed_disk_id    = azurerm_managed_disk.managed_disk[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.rhel8vm[count.index].id
  lun                ="10"
  caching            = "ReadWrite"
}