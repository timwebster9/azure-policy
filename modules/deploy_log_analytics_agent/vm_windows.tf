resource "azurerm_network_interface" "windows_vm" {
  name                = "windows-vm-nic"
  location            = azurerm_resource_group.policy.location
  resource_group_name = azurerm_resource_group.policy.name

  ip_configuration {
    name                          = "windows-vm-ip"
    subnet_id                     = azurerm_subnet.host_sn.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                = "windows-vm"
  resource_group_name = azurerm_resource_group.policy.name
  location            = azurerm_resource_group.policy.location
  size                = var.vm_size
  admin_username      = "azureuser"
  admin_password      = "sdafasdfsaghdgkjhIOU897£"

  depends_on = [
      azurerm_management_group_policy_assignment.policy_assignment_windows_vm
  ]

  network_interface_ids = [
    azurerm_network_interface.windows_vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}