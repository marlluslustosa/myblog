---
title: P2V / V2V – Conversion of environments – XenServer 7.0
author: marllus
categories: [ technology ]
layout: post
image: assets/images/migration.jpg
featured: true
hidden: true
lang: en
---

Today I&#8217;ll discuss P2V and V2V of operating systems. Well P2V and V2V, are terms that refer to system migration. And migration (since before Christ – <a href="http://www.ushistory.org/civ/4g.asp" target="_blank">40 years of migration of the Hebrews to Canaan</a> rs) is a painful process and sometimes costly (of time and physical resources).

**P2V** (Physical to Virtual): is used when you want to turn a physical-to-virtual machine (migration of a PC or notebook for a VIRTUALIZER – ex. Xenserver);

**V2V** (Virtual to Virtual): is used when you want to turn a virtual machine to another virtual (usually when you&#8217;re migrating Vms between different Virtualizers – ex. Vmware -> Xenserver)

Well, in my tutorials I always like to explain the &#8220;State of the art&#8221; or the &#8220;Foundation&#8221; for constructing of their own knowledge through accurate and detailed information of studied point. In my head, only a how-to step-by-step, without the whys, becomes merely a &#8220;shut up and follow me&#8221;. That&#8217;s why, in almost all the tutorials I made, when I get in the &#8220;hands-on&#8221; I post links with the procedures. If you can raise questions about what you want to do and plan for such solutions, until a robot do the step by step.

I guarantee you that if you always follow this principle, your life will change, because the whys will become increasingly frequent. Remember that.

Well, coming back, without further delays, I will present (in steps) how occurs the process of migrating of a physical or virtual machine to a VM on Xenserver 7.0. These procedures are generic. The software used to carry out operations can be severals. At the end, I will put tutorials for you follow which mentioning useful tools for carrying out the procedures.

1. Create an image of the hard disk of the machine;
  
1.1. In this step, it usually starts a cd/usb of boot of some backup program (clonezilla, G4L, etc) on the machine and it’s copied the entire hard disk, creating an image at the end of the process. This image should be kept.

2. Create a VM with the same features of CPU, RAM memory, hard disk and OS (if you have template for it in the list of templates from XenServer – otherwise using the template other media install).
  
2.1. This step is pretty simple, just don&#8217;t install any OS in VM. Just create it and leave it there off.

3. Start the VM for cd/usb of boot from the same program that backed up from the source machine and restore that image on new disk that you just created to the VM.
  
3.1. When the restore process is complete, usually occurs the VM cannot start yet, because information of initrd/grub (if the machine is GNU/Linux) are still pointing to the old kernel.

If the VM in question is not the GNU/Linux, then skip to step 5.

4. Update initrd image, grub and paths of the disks in/etc/fstab
  
4.1. In this step, basically, you will have to mount all directories from the VM in chroot from a livecd/usb Linux and then create a new image for the initrd.

5. After that, you will have a functional VM inside your Xenserver virtualization environment.

Only these 5 steps are required for migration P2V or V2V Windows/GNU/Linux where the destination is the Xenserver 7.0

Additional steps are necessary for the optimization of VM, like the conversion of same of HVM for PV (modes of virtualization &#8211; if you don&#8217;t know what is this click <a href="http://ports.marllus.com/2016/02/17/pv-hvm-hvm-com-drivers-pv-pvhvm-pvh-no-xenserver-a-sopa-de-letrinhas-da-virtualizacao/" target="_blank">here</a>) and the installation of the xentools (xen drivers for Network/disc &#8211; if you don&#8217;t know what it is click <a href="http://ports.marllus.com/2016/02/17/o-xenserver-tools-xenserver-6-5/" target="_blank">here</a>)

Well, like I said, these are the generic steps to climb a VM on a Xenserver virtualization environment where the source was a VM from other virtualization system or a physical machine.

The following PDF, originated from a colleague (Germano Dias) of the institution where I work (Federal University of Ceará) will support the practical part of all information that I passed in this stream. In this is used Clonezilla software (GPL) for backup and restore of disks.
  
Download <a href="http://ports.marllus.com/wp-content/uploads/2016/02/GNU-Linux-P2V-e-V2V-para-XenServer-6.5.pdf" target="_blank">here</a> the PDF.

Other tutorials can serve as a complement or alternative to this procedure:

Tutorial using the dd command: <a href="http://www.lewan.com/blog/2011/04/14/p2v-conversion-of-linux-virtual-machine-for-xenserver" target="_blank">http://www.lewan.com/blog/2011/04/14/p2v-conversion-of-linux-virtual-machine-for-xenserver</a>
  
Another tutorial using the clonezilla: <a href="http://www.ibm.com/developerworks/br/library/l-clonezilla/" target="_blank">http://www.ibm.com/developerworks/br/library/l-clonezilla/</a>
  
You can also use G4L Ghost 4 Linux program for disk backup (as an alternative to the clonezilla) and that comes in the package Hiren&#8217;s bootCD 15.2: <a href="http://www.hiren.info/pages/bootcd" target="_blank">http://www.hiren.info/pages/bootcd</a>

Well, I hope you enjoyed and until the next! Questions and suggestions are welcome! Hugs!

References:

<a href="http://www.ushistory.org/civ/4g.asp" target="_blank">http://www.ushistory.org/civ/4g.asp</a>
  
<a href="http://www.ibm.com/developerworks/br/library/l-clonezilla/" target="_blank">http://www.ibm.com/developerworks/br/library/l-clonezilla/</a>
  
<a href="http://www.lewan.com/blog/2011/04/14/p2v-conversion-of-linux-virtual-machine-for-xenserver" target="_blank">http://www.lewan.com/blog/2011/04/14/p2v-conversion-of-linux-virtual-machine-for-xenserver</a>
  
<a href="http://www.ppgia.pucpr.br/~jamhour/RSS/TCCRSS08A/Diego%20Lima%20Santos%20-%20Artigo.pdf" target="_blank">http://www.ppgia.pucpr.br/~jamhour/RSS/TCCRSS08A/Diego%20Lima%20Santos%20-%20Artigo.pdf</a>
  
<a href="http://www.hiren.info/pages/bootcd" target="_blank">http://www.hiren.info/pages/bootcd</a>
  
<a href="http://ports.marllus.com/wp-content/uploads/2016/02/GNU-Linux-P2V-e-V2V-para-XenServer-6.5.pdf" target="_blank">http://ports.marllus.com/wp-content/uploads/2016/02/GNU-Linux-P2V-e-V2V-para-XenServer-6.5.pdf</a>
  
<a href="http://ports.marllus.com/2016/02/12/o-xenserver-tools-xenserver-6-5" target="_blank">http://ports.marllus.com/2016/02/12/o-xenserver-tools-xenserver-6-5</a>
  
<a href="http://ports.marllus.com/2016/02/12/pv-hvm-hvm-com-drivers-pv-pvhvm-pvh-no-xenserver-a-sopa-de-letrinhas-da-virtualizacao" target="_blank">http://ports.marllus.com/2016/02/12/pv-hvm-hvm-com-drivers-pv-pvhvm-pvh-no-xenserver-a-sopa-de-letrinhas-da-virtualizacao</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> <span id="result_box" class="short_text" lang="en"><span class="">This</span> work <a href="http://marllus.com/xenserver" target="_blank">Marllus</a>, is licensed with a <span class="">license </span></span><a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank">Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</a>.
</p>

&nbsp;
