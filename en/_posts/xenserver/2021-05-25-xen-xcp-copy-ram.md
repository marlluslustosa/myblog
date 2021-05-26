---
title: Xenserver/XCP-ng - Copy of VM with RAM
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/cofre-mar.jpg
image-ref: <a href="https://www.reddit.com/r/blender/comments/1zn20x/treasure_chest_floating_in_the_ocean_it_turned/">Treasure chest floating in the ocean</a>
tags:
- xenserver
- xcp-ng
- VM copy
- ram
- snapshot
- Copy with ram
- disk and memory
id-ref: copia-vms-ram
hidden: true
lang: en
---

The following article aims to register a method used to copy VMs with RAM and disk, without downtime between Xenserver / XCP-ng virtualization hosts.

#### The state - and the problem

As you know, both Xenserver and XCP-ng have a feature called Storage Xen Motion (version for [Xenserver](https://docs.citrix.com/en-us/xenserver/7-1/vms/migrate.html) and [XCP-ng](https://xcp-ng.org/docs/updates.html#xcp-ng-7-5-7-6-and-live-migrations)), whose function is to migrate live VMs from one place to another, without relying on shared storage, and , thus, maintaining the current state of the RAM / CPU, that is, without losses or service unavailability. The problem is that, although it works well for migration, when you want to copy this VM, things get a little complicated.

The point is that, with the withdrawal of a snapshot with RAM ([disk and memory](https://docs.citrix.com/en-us/xencenter/7-1/vms-snapshots-about.html)), you can only, by default, return to this state using the VM itself where you performed the process. This means that you either migrate the VM itself or you will have to copy it and re-connect this clone to the destination host. Then, it would lose the RAM state.

I went through a problem that challenged me recently. I had to copy a VM to another virtualization environment, however, it would have to go with RAM, without stops and without reboots. The machine would have to be a copy, as it would be reused for other purposes and they needed it to be in the same way as the original VM, without rebooting or terminating running processes.

NOTE: the version of the source virtualization host was Xenserver 7.0, so you could not use the continuous replication feature with RAM, present in [XCP-ng](https://xen-orchestra.com/blog/devblog-6-backup-ram/).

With that, I started a little saga; more because I thought it would be easily resolved than actually thinking that this was a very big problem. I started taking snaphots, exporting, creating templates, exporting, returning and nothing. I looked for technical manuals on copying VMs with RAM and nothing. I only found tutorials step by step for taking a snapshot with RAM and, at most, exporting these to templates, but, well, if I take a snapshot with RAM, it is assumed that your export should go, by default, with RAM enabled , no?

Well, a friend suggested a parameter called “preserve-power-state”, which I had never used, but heard about - like that caviar story, you know. I tested copying this suspended VM, preserving the state, and it didn't work. So, I thought that now it would work to export snaphost with RAM, enabling this parameter. So, there I went:

For snapshot with RAM, I used xencenter by checking the disk and memory option. After finishing, Setei that this snapshot would not be a template:

```bash
xe snapshot-param-set is-a-template=false uuid=<snapshot uuid>
```

Then I exported the snapshot to XVA with the blessed option enabled:

```bash
xe vm-export uuid=<snapshot uuid> filename=<NameHere.xva> preserve-power-state=true 
```

What happened was that after the last procedure, the VM was exported as XVA. So, I transported this file to another virtualization host (and now I tested it on another Xenserver with the same version as on a higher XCP-ng). After the file on the other side, I did a simple import command:

```bash
xe vm-import filename=<Namehere.xva> preserve=true sr-uuid=<uuid>
```

After that, the VM was magically imported with a suspended state, as if it had been paused (the state of the snapshot with RAM). Through Xencenter / XCP-center you can see this state through this icon <img src="/assets/images/suspended.png"> . Then, through xencenter / xcp-center (or command line), I clicked resume and she started from the point that she had removed the *snapshot*, with RAM and without any kind of stopped process.

Well, that was it. I decided to write this process, in addition to documenting it, because I couldn't find any other article that spoke exactly about that specific point. This can certainly help someone in the future!

*NOTE: As previously mentioned, Xen Orchestra has a feature called [continuous replication](https://xen-orchestra.com/blog/devblog-6-backup-ram/), where it is possible to replicate VMs between different hosts and storages , with RAM enabled, which eliminates those manual steps that I described in the article (which the resource can do under the hood). But, my case was that it was coming from Xenserver and that didn't work in this version. So, how do you say: CLI on them! :)*
