# Desc
- CTF hypervisor is providing the interface that enables guest execute code from host privilege,
  however, it only allows the guest who knows the key and algorthims.

- To simplify the case, CTF hypervisor is by default using the same kernel page table as guest does,
  so you don't need to care about the guest function callback is whether accessible by host or not.

# Challenge
- Exploit the processor privilege , and execute VMX instruction without patching the hypervisor
- Get the VMCS pointer 

# Logical RoadMap
- Hypervisor generates an interface key by XOR EPT pointer for number of rounds, which is equal to 
  the number of processor core, the key(s) generation is part of the VM initialization, you might want
  to analysis the logic of it in hypervisor to find out the key.

- After getting the key, you might need to analysis the usage of it in VMCALL interface traps
  then should be able to escalate the current privilege from kernel to VMX mode.
 

# Solution
- Kernel debug -> set breakpoint on VM initialization -> save the key
- Analysis how to use the key and the algorithms that used by decrpyting VMCALL interface 
