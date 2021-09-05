resource "azurerm_network_interface" "linux_vm" {
  name                = "example-nic"
  location            = azurerm_resource_group.policy.location
  resource_group_name = azurerm_resource_group.policy.name

  ip_configuration {
    name                          = "linux-vm-ip"
    subnet_id                     = azurerm_subnet.host_sn.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = "linux-vm"
  resource_group_name = azurerm_resource_group.policy.name
  location            = azurerm_resource_group.policy.location
  size                = var.vm_size
  disable_password_authentication = false
  admin_username      = "azureuser"
  admin_password      = "sadf8sa7asfas!"

  depends_on = [
      azurerm_management_group_policy_assignment.allow_sig_only
  ]

  network_interface_ids = [
    azurerm_network_interface.linux_vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # This should be allowed
  source_image_id = var.allowed_source_image_id

# This should be disallowed because it's not using an allowed image gallery source image
#   source_image_reference {
#     publisher = var.source_image_publisher
#     offer     = var.source_image_offer
#     sku       = var.source_image_sku
#     version   = var.source_image_version
#   }
}