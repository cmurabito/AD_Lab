# AD_Lab
The purpose of this repository is to document my progress in my Active Directory homelab. Hyper-V will be utilized as the hypervisor of choice during this process. Progress will constantly be updated below along with a table of contents for easier navigation.
# Table of Contents
* [Network Diagram](#network-diagram)
* [Initial Setup](#setting-up-windows-server-vm-within-hyper-v)
* [Configuring Networking](#configuring-networking)
* [Installing AD DS](#installing-active-directory-ds)
* [Changing Server Name](#changing-server-name)
* [Enabling DHCP](#enabling-dhcp)
* [Preventing Future DNS Issues](#preventing-future-dns-issues)
* [Connecting Windows VM to Domain](#connecting-windows-vm-to-domain)
* [Creating Users](#creating-users-in-ad)
* [FSMO Roles](#a-little-bit-about-fsmo-roles)
* [Configuring DNS](#configuring-dns)
* [Breaking DNS](#intentionally-breaking-dns-and-fixing)
* [Creating OU Structure](#creating-ou-structure)
* [Creating Security Groups](#creating-security-groups)
* [AGDLP](#agdlp)
* [Delegation](#delegation)
* [Password Policy and Account Lockout](#password-policy-and-account-lockout)
* [GPOs](#gpos)
* [GPResult/RSOP.msc](#gpresultrsopmsc)
* [File Services](#file-services)
* [Deploying MSI Software via GPO](#deploying-msi-software-via-gpo)
* [Loopback Processing](#loopback-processing)

# Documentation
## Network Diagram
For this lab setup we are going to be connecting our domain controller to pfSense that will act as a gateway. We will also be running a LAN network for our domain and it's client machines on Hyper-V so that we can keep our domain network properly segmented from the home network. This will eventually be updated to include a second domain controller for redundancy.

<img width="641" height="761" alt="Updated network diagram" src="https://github.com/user-attachments/assets/3086320f-1d0c-461a-9d65-e3c1a9496356" />

## Setting Up Windows Server VM Within Hyper-V
My first step in this homelab was to install Windows Server 2022 within Hyper-V.

<img width="1919" height="1028" alt="Screenshot 2025-12-21 183314" src="https://github.com/user-attachments/assets/12facdbf-d3ca-4f8a-be46-67f14d31611e" />

From Hyper-V, on the right hand side, we can create a new virtual machine by selecting "New" and then "Virtual Machine", which brings us into the "New Virtual Machine Wizard".I wanted to provision this machine with around 8GB of memory, so I entered 8192 into the text box below, although if you're copying this you can put whatever you feel is best.

<img width="701" height="533" alt="Screenshot 2025-12-21 183612" src="https://github.com/user-attachments/assets/d0237d31-c237-4b4c-8e7f-76abc1897971" />

Then we get to the virtual hard disk step, I left this as it was besides the Size box, which I knocked down to 100GB, since this is a home lab and for my purposes I do not think I will be needing more than that.

<img width="699" height="531" alt="Screenshot 2025-12-21 184005" src="https://github.com/user-attachments/assets/00cd5234-3218-4ed0-8509-3bc56be428c1" />

Then on the next screen we can configure how we want the machine installed. This is Hyper-V, and we are using the Server Evaluation .iso, so we will select .iso and specify our location and then continue until we finish.

<img width="701" height="528" alt="Screenshot 2025-12-21 184017" src="https://github.com/user-attachments/assets/0da8744f-82c0-426f-af6f-13e904705c36" />

The next step that we have to do is configure our networking. My idea for this is to have the server connected to the internet, as well as have an extra adapter for an internal network where a virtual Windows 11 machine can connect.We do this by creating an external adapter through the virtual switch manager, as well as an internal adapter and connecting both of them to our new virtual machine through it's network settings.

<img width="716" height="676" alt="Screenshot 2025-12-21 184106" src="https://github.com/user-attachments/assets/4d7e4bcf-6c4d-4a30-8112-2826741f4f0b" />
<img width="714" height="681" alt="Screenshot 2025-12-21 200507" src="https://github.com/user-attachments/assets/f8ba9535-3d52-45bf-ada6-c4009c7f9f75" />
<img width="708" height="678" alt="Screenshot 2025-12-21 200732" src="https://github.com/user-attachments/assets/1738b664-1ece-4f25-a87b-1a9fe397785d" />

Once this is done, we can start with the installation of Windows Server 2022. First we start and connect to our virtual machine...

<img width="1019" height="865" alt="Screenshot 2025-12-21 184638" src="https://github.com/user-attachments/assets/88f44940-7b41-4553-ad3c-f32b6346b709" />

We then go through the proper steps to install it, making sure to select the option with "Desktop Experience". This ensures we get the full GUI along with windows server.

<img width="1021" height="862" alt="Screenshot 2025-12-21 184707" src="https://github.com/user-attachments/assets/5c915c0e-011e-440e-84ff-3fef509d1a76" />

We then create a password for our lab, I like to make mine at least 12 characters utilizing uppercase, lowercase, numbers, and special characters.

<img width="1022" height="860" alt="Screenshot 2025-12-21 184955" src="https://github.com/user-attachments/assets/9f2be0dd-0cd5-450b-8b3f-bb6fcd00194d" />

## Configuring Networking
To configure our networking, we want to make sure that we set a static IP for our second ethernet adapter (internal network), leaving our first ethernet adapter (external network) untouched. This will allow the server to have an external internet connection while providing an internal connection for our virtual Windows 11 VM to attach to. We will set the static IP to 192.168.10.1 with a subnet of 255.255.255.0, leaving the gateway untouched, and setting our DNS as the same static IP 192.168.10.1.

<img width="1362" height="869" alt="Screenshot 2025-12-21 190549" src="https://github.com/user-attachments/assets/120468e7-4a59-48b3-a87f-1691f5657e5c" />

## Installing Active Directory DS
AD DS is the core Windows Server role for network identities, resources, and security. This will give us the power to enforce things like group policy and access control, as well as enable authentication. It is therefore essential that we install and configure it for our lab. This will provide a single point of administration and ensure users can log in and access resources within the lab environment. First we open the "Add Roles and Features Wizard".

<img width="1363" height="866" alt="Screenshot 2025-12-21 190741" src="https://github.com/user-attachments/assets/28a12c99-30d3-4ffb-adb9-84f67e2d0f32" />

We will hit next until we get to "Server Selection" and make sure our server is selected, which it should be by default.

<img width="1361" height="870" alt="Screenshot 2025-12-21 190802" src="https://github.com/user-attachments/assets/ea9a5a90-5fec-4925-a29e-06e17d60b850" />

We will then get to "Server Roles" and we will make sure that "Active Directory Domain Services" is selected.

<img width="1366" height="871" alt="Screenshot 2025-12-21 190820" src="https://github.com/user-attachments/assets/f0081448-a5e7-461d-b564-6979d31d707c" />

It will then install the feature, and ask us to set up our domain. This should appear within the text box after installation.

<img width="1360" height="874" alt="Screenshot 2025-12-21 190852" src="https://github.com/user-attachments/assets/60fe8839-a3f5-4132-b749-9932e7ed4814" />

When we go into that menu, we can select "Add a new forest" and specify a domain. For this I am choosing "Lab.local", feel free to get creative with this even though I am keeping it simple.

<img width="1367" height="873" alt="Screenshot 2025-12-21 191023" src="https://github.com/user-attachments/assets/181639ac-ce0b-4173-914f-df6c5191822c" />

We'll continue through and come to the "Additional Options", It will specify a NetBIOS domain name. Do not worry that this does not include the .local from the previous step.

<img width="1360" height="869" alt="Screenshot 2025-12-21 191539" src="https://github.com/user-attachments/assets/1efbfe5c-9f51-4153-92ec-35c76260b9ec" />

After a restart you should be greeted with the login screen. You will see underneath the credentials the name of your new forest and will be able to log into the administrator account with the same password you have created during setup.

<img width="1363" height="863" alt="Screenshot 2025-12-21 192100" src="https://github.com/user-attachments/assets/58cad782-547e-4f7a-b2d6-465ba3069231" />

## Changing Server Name
Its normally best practice to create a specific server name for your Windows Server that is useful. This can range from a variety of things but is usually defined by what the server is being used for. For our purposes we will name this one "LAB-DC-01", since we are using it for a "LAB", it is a "DC" or "Domain Controller", and it is number "01".

<img width="1363" height="875" alt="Screenshot 2025-12-21 192300" src="https://github.com/user-attachments/assets/0b7ad3c9-2201-452e-a0e6-daa7dac020e2" />

After a restart, we can verify our settings in the Local Server menu.

<img width="1367" height="874" alt="Screenshot 2025-12-21 192447" src="https://github.com/user-attachments/assets/5e74a922-13d3-4ec4-8847-69b6c114230f" />

## Enabling DHCP
In order for our server to hand out IP addresses to our internal network, we are going to have to enable DHCP. We can do this by first installing this as a role, just like when we installed AD DS, so go to "Add Roles and Features" and click on DHCP Server, continue until you get to this section.

<img width="1359" height="867" alt="Screenshot 2025-12-22 102852" src="https://github.com/user-attachments/assets/b9e3c9f1-5167-487b-b15c-6edc42bfdb33" />

The next section is pretty straightforward as well, just keep clicking on continue.

<img width="1357" height="867" alt="Screenshot 2025-12-22 102917" src="https://github.com/user-attachments/assets/768c0cf7-366f-4eb4-a604-3a87782f77a4" />

Now our Goal is to configure a scope. A scope is a range of IP addresses that will be either provisioned or reserved for devices connecting to our server. To do this we can open "Tools" and select "DHCP".

<img width="1358" height="870" alt="Screenshot 2025-12-22 103012" src="https://github.com/user-attachments/assets/d04087be-c4fc-4561-9cba-555cf985eff3" />

This will open the DHCP server manager. Now we select more actions, and then "New Scope".

<img width="758" height="563" alt="Screenshot 2025-12-22 103023" src="https://github.com/user-attachments/assets/e800c8a4-32d4-4bf6-ab2b-8aaa12e41cf3" />

The "New Scope Wizard" will pop up, we can then enter in an IP address range. Even though i have no plans to use 200 devices, I am going to create a range of 192.168.10.1 - 192.168.10.200 just for this lab's sake.

<img width="1350" height="697" alt="Screenshot 2025-12-22 104754" src="https://github.com/user-attachments/assets/a2f2d8aa-517d-49bc-957a-cae8426c880d" />

It will then ask us if we want to create exclusions. An exclusion is an IP range that will be reserved for any devices that we want to add in the future. I do plan on adding more management devices in the future, such as a second server, and will create an excluded address range of 192.168.10.1 - 192.168.10.30.

<img width="1025" height="634" alt="Screenshot 2025-12-22 104803" src="https://github.com/user-attachments/assets/6c425641-ab3e-4268-a7f8-c0d9f321bfa7" />

The next section we will be looking at is the router, and it will ask us the IP for the default gateway. Now, you can leave this blank if you do not want the computers connecting to your domain to have internet, but for learning purposes and because I do like to rabbit hole, I will be configuring NAT in the future. So I will set this to 192.168.10.1. (It should be noted, earlier in this lab I configured the IP of the server to this IP address, but changed the IP of the server to 192.168.10.10 later because of the network configuration I want to set up.)

<img width="1355" height="842" alt="Screenshot 2025-12-22 104840" src="https://github.com/user-attachments/assets/b9281389-1633-49ec-9d0a-fae3c8eec410" />

Now, we get to the domain name and DNS servers section. If DNS is enabled on your server, this should automatically populate. If it does not automatically populate, you can type in the server name(In my case the name of the forest, Lab.local) and it should pull the IP into the next box.

<img width="1352" height="837" alt="Screenshot 2025-12-22 105003" src="https://github.com/user-attachments/assets/c75d4e90-6cf8-4698-be03-bfbebb17e84d" />

Then we simply state that we want to activate this scope now.

<img width="1356" height="833" alt="Screenshot 2025-12-22 105026" src="https://github.com/user-attachments/assets/c36d822a-6969-4270-a595-7f4eb8958c5e" />

That should do it for DHCP configuration!

## Preventing Future DNS Issues
I wanted to go ahead and prevent any DNS issues in the future so I pulled up the DNS Server Manager.

<img width="1356" height="871" alt="Screenshot 2025-12-22 104121" src="https://github.com/user-attachments/assets/bec6960b-13c3-41d8-af03-3961a9671c26" />

I then went to interfaces, and selected the IP of the internal ethernet adapter's interface.

<img width="1359" height="862" alt="markup" src="https://github.com/user-attachments/assets/268bd7a1-fcd9-4471-80f0-dc2c04b45b2b" />

## Connecting Windows VM to Domain
Now its time to connect our first Windows 11 VM to the domain! This assumes you already have a Windows VM setup. It is as simple as going into Settings, searching for Access Work or School, selecting Connect and "Join this device to a local Active Directory domain", and then inputting the name of our domain, which is "Lab.local".

<img width="922" height="749" alt="Screenshot 2025-12-22 105518" src="https://github.com/user-attachments/assets/c537ecca-7c77-4358-87e3-846489d27e26" />

When prompted for credentials, we can input our credentials, and then select skip on the next section, the computer will then restart and be connected to our domain. Now we need some users!

## Creating Users in AD
If we go to Tools, and then Active Directory Users and Computers, we can create managed users that will be able to log in to our domain connected machines. We do this by selecting Users, and then right clicking and selecting New > User. For my first User I figured Jason Bourne would be a lovely employee and my company has given him a great offer he can't refuse. We can enter a name for him, and a username as well. Keep in mind when creating usernames to stick to a naming scheme, his username will be jbourne.

<img width="1356" height="829" alt="Screenshot 2025-12-22 105728" src="https://github.com/user-attachments/assets/8fd381be-f321-4968-ad59-ad4376aacfa6" />

On the next section it will ask to set a password, and will give us some options such as "User must change password on next logon", we want to set an easy temp password to remember, and then when he theoretically logs in for the first time it will ask him to change that to something he wants. We follow that workflow and then we should be able to get a successful login!

## A Little Bit About FSMO Roles
FSMO stands for "Flexible Single Master Operations" and are Active Directory tasks that must be handled by one domain controller at a time in order to avoid conflicts. Active Directory is a multi-master system although these roles are single-master by design. In a multi-master system, more than one server can make changes at the same time, which means all domain controllers can create users, change passwords, and modify group membership. AD uses these roles for critical tasks where a conflict could be dangerous, for example, two domain controllers modifying the schema at the same time. There are five of these roles, two at the Forest Level, and three at the Domain Level. 
### Forest Level FSMO Roles

* Schema Master
* Domain Naming Master

### Domain Level FSMO Roles

* RID Master
* PDC Emulator
* Infrastructure Master

So, what exactly do these roles do? Well, let's break down each one.

The Schema Master controls all changes to the Active Directory schema. The schema is defined by object types, such as user, computer, group, etc., and attributes, such as an email or a phone number. It is used when extending the schema, which is rarely going to be part of normal operations. If this role goes down, then schema changes will fail but normal authentication will still continue, as well as directory operations. There is only one per forest and should only be online when schema changes are needed.

The Domain Naming Master controls adding and removing domains in the forest and manages application directory partitions. It is used when creating a new domain or a tree, as well as removing a domain. If it goes down, then you won't be able to add or remove domains, but the existing ones will continue working normally. There is also only one per forest.

The RID Master's job is to allocate RID pools to domain controllers. These RIDs are used to create unique SIDs for users, groups, and computers. It is used anytime a domain controller creates a new security principal, and RID pools are requested periodically by domain controllers. Domain controllers will use existing RID pools, so short term, there will be no effect if this goes down, although long term, you will eventually be unable to create users, groups, or computers. There is one of these per domain.

The PDC Emulator is the most critical FSMO role. It handles Password change priority replication, account lockout processing, time synchronization, NTLM authentication and legacy compatibilty, as well as GPO editing coordination. It is used at every login, for every password change, and time checks across the domain. If this goes down it can cause authentication delays, password changes that don't correctly work, and Kerberos failures caused by time drift. This should be on the most reliable domain controller and be backed by redundancy planning and monitoring. There is one per domain.

The Infrastructure Master maintains cross-domain object references and updates group memberships when members are from other domains. It is used when users from different domains are added to groups, and for periodic reference updates. If this goes down, group memberships may show outdated information, although in a single domain forest, there should be little to no effect. There is only one per domain.

## Configuring DNS
What is the importance of DNS? DNS is a critical service that your domain controller needs in order for your network to operate. This is what allows computers, users, and services to find each other on the network. If you are using AD then this is required and should be installed on the domain controller. It will help users log in to the domain, services like printing and file servers to locate servers, and AD to replicate properly. So how do we correctly configure this?

First, we need to install DNS as a role. This is done by opening "Add Roles and Features" and selecting "DNS". After this is installed, you can select "Tools" > "DNS" and this will open up the DNS Manager.

<img width="1010" height="863" alt="Screenshot 2025-12-30 184155" src="https://github.com/user-attachments/assets/04178264-26eb-40b5-85f5-f98f17a664b3" />

Under here we can see that we have Forward Lookup Zones, Reverse Lookup Zones, Trust Points, Conditional Forwarders, Root Hints, and Forwarders. We will focus on the first two for this configuration. Forward lookup zones should have been automatically populated from the install, so we wont have to worry too much about that. A Foward Lookup Zone is a database on the DNS Server that maps Hostnames to IP Addresses. A Reverse Lookup Zone will map an IP Address back to a Hostname, allowing DNS to determine the computer's name from it's IP. This should be empty by default and is what we will need to configure. In order to do this we can click on Reverse Lookup Zones, right click, and click "New Zone". This will bring us to the "New Zone Wizard".

<img width="489" height="383" alt="Screenshot 2026-01-01 175744" src="https://github.com/user-attachments/assets/0a69e60f-6f89-4e81-83d5-0329b0fe835f" />

We will then make sure that "Primary Zone" is selected and will click on next.

<img width="493" height="387" alt="Screenshot 2026-01-01 175803" src="https://github.com/user-attachments/assets/7d4e8e45-d292-4e0e-b857-1c881269e448" />

Then we will make sure that "To all DNS servers running on domain controllers in this domain" is selected.

<img width="496" height="385" alt="Screenshot 2026-01-01 175815" src="https://github.com/user-attachments/assets/371eceef-4466-406e-a375-ebc6f75ca418" />

We will then create an IPv4 reverse lookup zone, so make sure that is selected.

<img width="492" height="387" alt="Screenshot 2026-01-01 175825" src="https://github.com/user-attachments/assets/2a1c649c-82a6-45d1-a722-c95654c19c32" />

The next menu we will enter our network ID, this should be the first three octets of your IP address you assigned your domain controller. So if you assigned 192.168.10.1, it will be 192.168.10.

<img width="489" height="382" alt="Screenshot 2026-01-01 175840" src="https://github.com/user-attachments/assets/92b888e9-e787-4515-a9cf-6ebeeeb3fa7c" />

Make sure "Allow only secure dynamic updates" is selected.

<img width="488" height="377" alt="Screenshot 2026-01-01 175852" src="https://github.com/user-attachments/assets/b65cc47f-85be-488e-b3f8-b531ef3c2016" />

And then hit finish to complete this configuration.

<img width="495" height="389" alt="Screenshot 2026-01-01 175904" src="https://github.com/user-attachments/assets/1857268b-b645-4155-9815-b9cf3b25b8d5" />

Our newly created zone should now be populated under Reverse Lookup Zones.

<img width="743" height="516" alt="Screenshot 2026-01-01 175915" src="https://github.com/user-attachments/assets/8a83efad-95e2-42e9-b885-bb7ac39b8664" />

After this, there is still one more thing we have left to do. If we run nslookup, we can see that our default server is unknown. This is because the name of our server is not resolving to our IP address that is populated.

<img width="1019" height="835" alt="Screenshot 2026-01-01 165836" src="https://github.com/user-attachments/assets/f09f9f12-8f2d-4313-a64d-ef625d6573f1" />

We will need to fix this. We can do that by heading into Reverse Lookup Zones, right clicking the zone we created, selecting properties, and changing the IP of the name server to our DC's IP address.

<img width="1016" height="858" alt="Screenshot 2026-01-01 170216" src="https://github.com/user-attachments/assets/d1614a96-4919-43f5-af5d-a71231bb80a9" />

After we do this, we will see that the default server name resolves to our DC's name, which in this situation is "LAB-DC-01.Lab.Local".

<img width="970" height="199" alt="Screenshot 2026-01-01 170257" src="https://github.com/user-attachments/assets/668f515d-bebf-454c-96f2-3f316aebe24d" />

How can we verify that this is running now? Well if we log on to our client VM and head into the command prompt, we can enter "ping LAB-DC-01.Lab.local" and see if we get a response. You should receive a reply back if DNS is working as expected.

<img width="1015" height="866" alt="Screenshot 2025-12-30 185552" src="https://github.com/user-attachments/assets/e978f089-eac6-4fad-b27f-8cc85fd8c5d2" />

DNS should now be configured within our Active Directory environment!

## Intentionally Breaking DNS and Fixing
So what happens if DNS fails? A few different things can occur, authentication can fail, services/computers can't find each other, etc.. Let's intentionally break DNS so that we can more easily identify these issues and how to resolve them. First, we are going to delete our forward lookup zone, "Lab.local".

<img width="1009" height="838" alt="Screenshot 2026-01-01 171753" src="https://github.com/user-attachments/assets/468a1da3-dc0d-4707-8718-6ae865ef30bc" />

Then on our client machine, we'll run a "ipconfig /flushdns" along with a "klist purge" command just to be safe.

<img width="517" height="244" alt="Screenshot 2026-01-01 172128" src="https://github.com/user-attachments/assets/42fa5ec8-7c03-498e-99b6-863c39ef32ab" />

We will also restart the netlogon service on our domain controller.

<img width="1017" height="757" alt="Screenshot 2026-01-01 172307" src="https://github.com/user-attachments/assets/48c8fe1b-557d-4006-85b7-d5e83588c36f" />

If we then logout and then log back in, we can see that we are still able to log in to this computer. No issue right? That's because the windows machine has the credentials cached and the user profile pulled onto it already. But what if somebody else tries to use this machine? Say another member of another shift comes in and sits down at this desk and attempts to log on. We're going to create a new user called "tester" and attempt to log on. As you can see, we get "We can't sign you in with this credential because your domain isn't available. Make sure your device is connected to your organization's network and try again. If you previously signed in on this device with another credential, you can sign in with that credential.". 

<img width="1010" height="748" alt="Screenshot 2026-01-01 172618" src="https://github.com/user-attachments/assets/d244df61-5c18-4d0f-b595-43e1ff36cca8" />

Why does this happen? Because without DNS correctly configured, our client machine is not able to find our domain controller, even though we are connected to that domain so to speak. So now we need to fix it. We can do this by rebuilding the forward lookup zone that we deleted. In order to do this, we can go to our domain controller, right click within "Forward Lookup Zones", and click "New Zone", and rebuild the zone "Lab.local". We should then be able to sign in.

<img width="1011" height="832" alt="Screenshot 2026-01-01 172936" src="https://github.com/user-attachments/assets/b300f30e-45e8-4eb8-8f8e-27ad27cbf7ad" />

## Creating OU Structure
OU stands for "Organizational Unit" and is utilized as a container object in order to organize, manage, and apply policies to users, computers, and other objects within a domain. In order to be able to apply group policy effectively within our domain, an OU structure needs to be created, which is exactly what we are going to do. First, we need to open Active Directory Users and Computers.

<img width="1013" height="754" alt="Screenshot 2026-01-02 124103" src="https://github.com/user-attachments/assets/e540fcc9-bd24-40a3-baad-58dd5ce725b3" />

Then, we need to right click on our domain, select new, then organizational unit.

<img width="1017" height="756" alt="Screenshot 2026-01-02 124133" src="https://github.com/user-attachments/assets/030b258d-3dea-492a-aee3-e087efbf944e" />

From here, we are going to create an organizational unit called "LAB_Enterprises" and create organizational units within that one for each department, and role, making sure we separate users and computers from each other. Many different IT teams in the real world will have different ways of going about this, but for the purpose of this lab this is how we will go about it.

<img width="1018" height="756" alt="Screenshot 2026-01-02 153233" src="https://github.com/user-attachments/assets/8143842a-1953-49d3-a96d-1b5c60b52669" />

## Creating Security Groups
Security groups are essential for AD and will simplify the process of doing things such as assigning permissions to access specific network folders. What a security group does is group users into one group so that you can more effectively apply policy. Let's go ahead and create some groups, which we will do by department. First we are going to navigate to the "Tools" section, and then select "Active Directory Users and Computers".

<img width="1017" height="761" alt="Screenshot 2026-01-08 190352" src="https://github.com/user-attachments/assets/d4274cc3-f7be-4acb-80d5-556b71dca09f" />

Then within "Users", we will right click and select "New" and then "Group".

<img width="1023" height="791" alt="Screenshot 2026-01-08 190424" src="https://github.com/user-attachments/assets/682cf019-60cb-4060-854f-7922f80aa1eb" />

This will bring us to a section where we can specify the name of this group. This one will be called "Human Resources" and we will make one for every other department as well. In this section you will see "group scope" and the options "Domain Local", "Global", and "Universal". I will take a second to explain these. "Domain Local" means you would be creating a scope for that domain and that domain only. "Global" would mean that you would create a scope for every domain that you have, and "Universal" is suited for if you had multiple companies that you were managing that each had their own forests and respective domains. We are going to stick to "Global" since we only have one domain.

<img width="1018" height="766" alt="Screenshot 2026-01-08 190453" src="https://github.com/user-attachments/assets/6be2319f-461e-4e50-906c-554d3e023183" />

If we now double click on a group, we can select "Members" at the top of the properties screen and add users to this group. We'll do this for each one of our departments.

<img width="1013" height="761" alt="Screenshot 2026-01-08 190732" src="https://github.com/user-attachments/assets/a41e641e-1d96-49da-bf65-bdb04bfb54be" />

Jason Bourne and Tyler Roberts in the Information Technology group

<img width="1017" height="764" alt="Screenshot 2026-01-08 190748" src="https://github.com/user-attachments/assets/7ca2b171-5118-48d3-b7ef-3e9a9f7e41be" />

Karen and John Smith in the Human Resources group

<img width="1019" height="765" alt="Screenshot 2026-01-08 190833" src="https://github.com/user-attachments/assets/c3c3cdd9-190d-469d-a3e8-e5c3a140e954" />

Hayley Williams and Brett Childers in the Sales group

<img width="1023" height="765" alt="Screenshot 2026-01-08 190903" src="https://github.com/user-attachments/assets/c4e82da4-95fa-4d4d-adaa-5f2f89d2483c" />

Also, since we are already in here, we will move our users to their respective locations in the OUs that we created in the last section.

<img width="1017" height="763" alt="Screenshot 2026-01-08 191235" src="https://github.com/user-attachments/assets/9a911c93-f7f1-4314-b150-f652ed1b8929" />

So now what kind of things can we do with these security groups? Well if we create a folder named "HR" or any other folder that a department or members of the company might need access to, then we can assign these security groups to that respective folder's sharing permissions. This allows us to customize who can access what within our Lab. We'll go ahead and do that now. First we will create an "HR" folder.

<img width="1021" height="768" alt="Screenshot 2026-01-08 191608" src="https://github.com/user-attachments/assets/cefe37be-0259-442f-9300-d743d2b2dda7" />

Then we will right click on that folder and select properties as well as click on "Share..." within the "Sharing" tab.

<img width="1022" height="766" alt="Screenshot 2026-01-08 191639" src="https://github.com/user-attachments/assets/19966db8-3bfa-47bf-81f3-26ba13a0b1ec" />

In the dropdown, we can select "Find People..." and enter in "Human Resources". Don't forget to click on "Check Names"! You will see it underlined when it has checked. We can then hit ok.

<img width="1019" height="765" alt="Screenshot 2026-01-08 191713" src="https://github.com/user-attachments/assets/95857e96-476f-4daa-aa4f-2df70367d3de" />

You'll now see it populated with the "Human Resources" group, this tells us that the users in that respective group will be able to access this folder with Read/Write permissions!

<img width="1023" height="766" alt="Screenshot 2026-01-08 191736" src="https://github.com/user-attachments/assets/10bd3528-3b07-41e1-91c5-bfba47ccb9c5" />

## AGDLP
The AGDLP model is a best practice approach for managing user permissions in Active Directory. Its important that we use this model when we create our security groups because of a few things. The benefits include simplified management, improved security, scalability, consistency, and for simplified auditing. So what does AGDLP stand for? It stands for Account, Global Group, Domain Local Group, Local Group, Permissions. Our user accounts will be assigned to global groups, which will be assigned to domain local groups, and then assigned the necessary permissions. This is how we implement this model. First, we'll open "Active Directory Users and Computers", right click within "Users", then select "New" and "Group". We are going to name this group "HR_Folder_RW" which tells us it is for the HR folder and will be for read/write permissions, and we will select "Domain Local".

<img width="1015" height="763" alt="Screenshot 2026-01-09 220509" src="https://github.com/user-attachments/assets/284d4956-bdf1-457b-b77d-a1e6e96e9ef8" />

Now we need to add our HR global group as a member of this group. This is done by opening our newly created security group's properties, clicking on "Add", and then typing in "Human Resources", clicking on "Check Names", and then "Ok".

<img width="1015" height="760" alt="Screenshot 2026-01-11 201637" src="https://github.com/user-attachments/assets/3cff8ff6-a638-4042-a0c5-71352290a3c3" />

We are going to go ahead and do this for all three of our departments, as they will all have their own folder that they can utilize. Once thats done, we can go into the respective folder's properties, and into "Advanced" underneath the "Security" tab, and assign our domain local groups as we see fit to their shared folders. This will allow all the users in our global group to have access to the specific resource that our domain local group does.

<img width="1014" height="766" alt="Screenshot 2026-01-09 221022" src="https://github.com/user-attachments/assets/bf46c358-d7dd-40c4-9d66-3ba46fef354d" />

We can hit "Add", then type in the name of the domain local group, and hit "Check Names", then "Ok".

<img width="1017" height="760" alt="Screenshot 2026-01-09 221052" src="https://github.com/user-attachments/assets/dac83767-cf27-42c9-8525-dc781f9ea751" />

We can now see that our domain local group we created now has permissions for that folder, and the AGDLP model has been applied to our server!

<img width="1015" height="759" alt="Screenshot 2026-01-09 221207" src="https://github.com/user-attachments/assets/572a916d-2b83-4b7f-b5c1-a4f0b7d98959" />

## Delegation
One thing that we might like to do in a production environment is delegate certain controls. For example, for something as simple as a password reset, we might want to delegate that to the helpdesk. Here's how we can do that. First we will need to create a security group that we are going to name "Helpdesk_Pass_Reset" within our newly created "Security Groups" OU.

<img width="1018" height="764" alt="Screenshot 2026-01-13 190244" src="https://github.com/user-attachments/assets/ffc45769-d828-4413-9793-3933fd5e0ee7" />

We will then right click on our "Sales" OU and select "Delegate Control". This will bring us into the "Delegation of Control Wizard".

<img width="1020" height="761" alt="Screenshot 2026-01-13 190353" src="https://github.com/user-attachments/assets/020a2431-842b-4339-85ad-4209305424ac" />

We will then type in "Helpdesk_Pass_Reset" and hit "Check Names".

<img width="1021" height="768" alt="Screenshot 2026-01-13 190414" src="https://github.com/user-attachments/assets/02683baf-440d-4dda-83f3-26255c0b282c" />

This will bring us into a "Tasks to delegate" menu. We will select the option "Reset user passwords and force password change at next logon."

<img width="1018" height="762" alt="Screenshot 2026-01-13 190434" src="https://github.com/user-attachments/assets/7f510038-4191-46bd-b976-daef1dd66e2c" />

After doing the above steps we will repeat them for our "HR" OU. Because we wouldn't want IT employees changing each other's passwords and leave that solely up to the admin, we will not do this for the "IT" OU. We will also want to add the "Information Technology" security group into the "Helpdesk_Pass_Reset" group we just created.

<img width="1020" height="764" alt="Screenshot 2026-01-13 190634" src="https://github.com/user-attachments/assets/026c761d-786d-42c1-9815-aeedcdd52c07" />

We can verify that our newly created security group has those permissions by going into the advanced security settings for the OU's that were made members for our said security group and look within the "Permissions" tab.

<img width="1022" height="754" alt="Screenshot 2026-01-13 190807" src="https://github.com/user-attachments/assets/5bc50803-36f3-4844-a65a-1e0f6ec9e315" />

Now members of our IT team should have the permission to reset passwords for any of our employees!

## Password Policy and Account Lockout
Another thing we are going to want to configure is a strong password policy and account lockout settings to help to prevent possible brute force attacks on our users. For our password policy, we are going to be configuring it so our users need at least 12 characters, with a password change every 30 days, as well as meeting complexity requirements. After 4 invalid logon attempts, we want their account to "lock out" after 4. Here's how we can do that. First we are going to open up "Group Policy Management" within the "Tools" tab.

<img width="1023" height="764" alt="Screenshot 2026-01-13 190952" src="https://github.com/user-attachments/assets/f69dde4a-09cf-4ebd-a247-e43e2016f36b" />

Once this is opened, we can go to "Forest" -> "Domains" -> "Lab.local" -> "Default Domain Policy", then go into "Settings" under that and scroll down to see our current password policy.

<img width="1018" height="761" alt="Screenshot 2026-01-13 191630" src="https://github.com/user-attachments/assets/fa7c750d-4e04-4451-974b-c0324f2218fa" />

If we right click on "Default Domain Policy" and click on "Edit", then it will bring us into the policy editor where we can make changes. You will see two sections here, Computer Configuration and User Configuration. Computer Configuration are settings that manage the workstation, while User Configuration is made up of settings that affect users. You will also notice the tabs Policies and Preferences. Policies are enforced settings while Preferences are settings that can be changed. For our password policy, we do not want this to be messed with, and it will affect the whole workstation, so we need to select "Computer Configuration" and "Policies".

<img width="1024" height="767" alt="Screenshot 2026-01-13 191643" src="https://github.com/user-attachments/assets/a0016588-9ad2-4574-a07d-c4ac503ff978" />

We will then need to navigate to "Windows Settings" -> "Security Settings" -> "Account Policies". In that section, you will see "Password Policy", "Account Lockout Policy", and "Kerberos Policy". We will only configure the first two, so let's start with "Password Policy".

<img width="1020" height="762" alt="Screenshot 2026-01-13 191720" src="https://github.com/user-attachments/assets/d3ff3e78-10db-40cc-bc0b-c70e842551a6" />

Within this menu we can right click on each setting and change it to what we desire it to be changed to. We will go with the settings we discussed in the beginning of this section.

<img width="1020" height="760" alt="Screenshot 2026-01-13 192234" src="https://github.com/user-attachments/assets/c513b682-11e6-48ff-a30a-a602543e3f22" />

We can then move on to "Account Lockout Policy" and configure the settings there as well. After defining a number of invalid logon attempts, it will automatically change the duration and lockout counter. We will leave those at 30 minutes.

<img width="1019" height="764" alt="Screenshot 2026-01-13 192354" src="https://github.com/user-attachments/assets/6b976777-f287-4884-baf5-122765aa0fbb" />

We then need to right click on the "Domain Controllers" OU in the management console and select "Group Policy Update".

<img width="1020" height="760" alt="Screenshot 2026-01-13 192506" src="https://github.com/user-attachments/assets/6702a539-374d-4155-b2f6-a2d96fd6facd" />

After this finishes, we can hit "Close".

<img width="1019" height="763" alt="Screenshot 2026-01-13 192517" src="https://github.com/user-attachments/assets/a7b343e0-f7b7-4f50-ace1-c10627bf6497" />

And a quick refresh will show our new settings are updated.

<img width="1018" height="765" alt="Screenshot 2026-01-13 192653" src="https://github.com/user-attachments/assets/05455bf5-caac-4277-941c-cee2c57fc7ed" />

To test our lockout policy, we can log onto our client VM and attempt to enter a wrong password one too many times. A lockout error will confirm our policy is active.

<img width="1025" height="766" alt="Screenshot 2026-01-14 192436" src="https://github.com/user-attachments/assets/0204e421-042b-450b-bdfa-2262c8c95ecc" />

We can also test our password policy by attempting to change the pass of a user to something that does not meet the requirements. If you get an error, your policy is working as intended.

<img width="1018" height="762" alt="Screenshot 2026-01-14 192535" src="https://github.com/user-attachments/assets/54584afa-c628-4f3e-aad8-80284fbdac29" />

## GPOs
Group Policy Objects(or GPOs for short) are a means by which we can customize settings, run scripts, or adjust security settings across our domain. We have a few that we want to go ahead and set for this Lab, those are going to be forcing screen lock after a specified period of inactivy, disabling USB devices, and creating a User Account Control policy. Let's dive into it, first we need to open group policy management.

<img width="1021" height="765" alt="Screenshot 2026-01-17 213551" src="https://github.com/user-attachments/assets/e349032b-64a4-4e6f-864e-100bd077a1d6" />

Then within "LAB_Enterprises", we want to right click, and select create a GPO in this domain and link it here.

<img width="1019" height="766" alt="Screenshot 2026-01-17 213625" src="https://github.com/user-attachments/assets/8b149fc5-5949-402a-b3a4-33f2f077409f" />

We're going to name it "Force Screen Lock" and right click on it and select edit. We always want to name our GPOs something that is in reference to what they actually do.

<img width="1019" height="763" alt="Screenshot 2026-01-17 213715" src="https://github.com/user-attachments/assets/c36b20f9-a856-4f84-ac91-805cad44f822" />

When the group policy management editor pops up, we then want to go "Computer Configuration" -> "Policies" -> "Windows Settings" -> "Security Settings" -> "Local Policies" -> "Security Options". Within "Security Options", there should be a setting named "Machine Inactivity Limit". We will go ahead and right click on that, select "Properties", and check the "Define this Policy Setting" box, and enter 600 seconds in the input field. This will make it so that after ten minutes of inactivty, the screen saver will be triggered and force a screen lock. Upon sensing any activity afterward, it will prompt the user to log back in. 

<img width="1021" height="763" alt="Screenshot 2026-01-17 214115" src="https://github.com/user-attachments/assets/9877f798-a49f-4f4c-ab9b-9b25c012bf53" />

Now that that is done, we can update our group policy and test it out. After updating the group policy and testing it myself, I can assure you it works on my end. Remember to also right click on the policy you just made and select "Enforced".

<img width="216" height="243" alt="Screenshot 2026-01-17 223222" src="https://github.com/user-attachments/assets/d47a223b-174d-46fb-b846-3e594e6ac31d" />

We'll now create a USB Restriction Policy, so that USB devices can not be plugged into client computers. This helps prevent any unauthorized software or malicious code running on client machines and is essential for security reasons. 

<img width="1018" height="769" alt="Screenshot 2026-01-17 223634" src="https://github.com/user-attachments/assets/079e4c7d-55e8-4b2e-9ac8-0959cf10b149" />

The setting we are searching for is named "All Removable Storage Classes:Deny all Access", and it is located under "Computer Configuration" -> "Windows Settings" -> "Administrative Templates" -> "System" -> "Removable Storage Access".

<img width="1015" height="748" alt="Screenshot 2026-01-17 224059" src="https://github.com/user-attachments/assets/2fdb2bc2-8f75-492f-a3a7-13851e041bac" />

We will enforce this as well.

<img width="1018" height="760" alt="Screenshot 2026-01-17 224330" src="https://github.com/user-attachments/assets/28919bbc-04e7-4465-8130-0d3acacccedf" />

The next policy is "User Account Control", this setting will be enforced to prompt standard users for an administrator's credentials when attempting to install software or change settings that require administrator privileges. This is important for security as well.

<img width="1021" height="763" alt="Screenshot 2026-01-17 224724" src="https://github.com/user-attachments/assets/45766ca7-a6de-47d5-b8d3-bbd9b27db712" />

It will be located under "Computer Configuration" -> "Policies" -> "Windows Settings" -> "Security Settings" -> "Local Policies" -> "Security Options". There are three that we will enable, the first setting being "Detect application installations and prompt for elevation".

<img width="1019" height="763" alt="Screenshot 2026-01-17 224907" src="https://github.com/user-attachments/assets/a535a94d-d932-461c-bc32-c7037c1e8a9e" />

The second being "Behavior of the elevation prompt for standard users" which we will change to "Prompt for credentials".

<img width="1018" height="761" alt="Screenshot 2026-01-17 225237" src="https://github.com/user-attachments/assets/fa58c9ca-455d-4bdf-b3da-b13cc5562675" />

The third being "Run all administrators in Admin Approval Mode".

<img width="1020" height="764" alt="Screenshot 2026-01-17 225602" src="https://github.com/user-attachments/assets/19af6179-3fbd-4dcd-9efb-909ad624b917" />

So how do these GPOs actually work? GPOs are created inside of a domain and linked to organizational units. Thus any OUs within what they are linked to will also inherit them. This brings us to the problem of conflicting GPOs. For example purposes, I have created a "Disable Display" GPO and an "Enable Display" GPO. "Disable Display" is linked to "Lab_Enterprises" while "Enable Display" is linked to the "IT" OU within its parent OU. So which GPO's settings do you think will apply?

<img width="415" height="558" alt="Screenshot 2026-01-19 120814" src="https://github.com/user-attachments/assets/17a01109-4eaa-4b18-a11a-517a2e244b6d" />

GPO inheritance works by using the LSDOU processing order. This stands for Local, Site, Domain, Organizational Unit. Sub-containers (OUs) will inherit from the parent container's settings unless there is a conflict in which case the GPO closest to the intended object will take precedence which means that currently "Enable Display" will take precedence. We can override this in two ways if we want to depending on our situation. The first is using the "Block Inheritance" feature, which allows us to stop any inheritance completely from GPOs outside of the selected OU. This can cause issues though considering that the "Default Domain Policy" is inherited. The second way is to enforce the GPO that we created, "Disable Display", so that it takes precedence before "Enable Display".

## GPResult/RSOP.msc
GPResult and RSOP.msc are both tools that show the effective group policy information applied to a user or computer. They can be useful when troubleshooting why a policy did or did not apply and comparing policy results between users or computers. The main difference between them is GPResult is a command line interface while RSOP.msc is a graphical interface. Let's go ahead and dive into these. First we are going to want to create a GPO named "Allow Remote Administration Exception". This GPO will allow us to open specific firewall exceptions to manage computers remotely. Since we already went over creating GPOs in the last section, I will not go over how to do this again and if you are reading this and would like to copy me, then a quick google search on where this policy setting is located will help you out. After this is done, we'll open command prompt, and we can type "gpresult" to get a help page on this command.

<img width="979" height="510" alt="Screenshot 2026-01-20 194034" src="https://github.com/user-attachments/assets/4a51b74f-e6a6-4fdb-a88a-4ff9d1b66c60" />

We can get policies applied to a specific user by using these flags, while also saving the output in an html format for easy reading.

<img width="652" height="81" alt="Screenshot 2026-01-20 194410" src="https://github.com/user-attachments/assets/691f5532-c5c7-4cc5-9a91-9a6e06b476ac" />

We can also get policies applied to specific computers as well. To do this we can use these flags down below.

<img width="911" height="78" alt="Screenshot 2026-01-20 194843" src="https://github.com/user-attachments/assets/2b45b158-05b7-487b-98b6-c15855b24f47" />

We can open these html files wherever we saved them, in this case our html file is located in our administrator profile folder. If we go ahead and open that, we can see which specific policies are applied to the computer in question, the details of said computer, etc.

<img width="1019" height="726" alt="Screenshot 2026-01-20 201518" src="https://github.com/user-attachments/assets/286751f3-1c8b-4597-9a57-68168b05652e" />

If we wanted to use RSOP.msc instead, all we have to do is open Group Policy Management, right click on "Group Policy Results", and open up the "Group Policy Results Wizard". 

<img width="751" height="550" alt="Screenshot 2026-01-20 201641" src="https://github.com/user-attachments/assets/b9337b2b-64f7-4df6-933e-f179d2a59f1b" />

We can click through this wizard and select "Another computer:" and type in the name of the system we want to pull the resultant set of policy from.

<img width="515" height="453" alt="Screenshot 2026-01-20 201741" src="https://github.com/user-attachments/assets/5d9c1bcd-86fc-4488-b12e-2a74e85e41d1" />

We can then select a user on that computer to display policy results for.

<img width="518" height="459" alt="Screenshot 2026-01-20 201755" src="https://github.com/user-attachments/assets/47f74948-4d3b-4466-bc96-39e0aeff899e" />

After this we click through the wizard and we'll arrive back in the Group Policy Management console and be able to interact with our results.

<img width="742" height="511" alt="Screenshot 2026-01-20 201828" src="https://github.com/user-attachments/assets/2955feb8-17d4-4f6e-9d0a-0ec710c546c3" />

## File Services
Another essential service that we can implement into our environment is a deployed file server. This will allow users across departments to effectively collaborate on their work. In order to do this, we are going to need to setup a file server. We will go through Hyper-V, create a new virtual machine, and configure a file server. I already have one started through Hyper-V, and have the name and IP address configured below.

<img width="1020" height="767" alt="Screenshot 2026-01-24 123337" src="https://github.com/user-attachments/assets/c32c2f60-7416-4500-be89-ba5a911b45e9" />

We are going to want to join this server to the domain, we can do that underneath the computer name settings. We will enter the name of our domain, "Lab.local".

<img width="1024" height="765" alt="Screenshot 2026-01-24 123548" src="https://github.com/user-attachments/assets/325635a5-30f9-4c62-8815-713879cce60e" />

We will then go into the "Add Roles and Features" wizard, and select "File Server" underneath "File and Storage Services".

<img width="1015" height="759" alt="Screenshot 2026-01-24 123846" src="https://github.com/user-attachments/assets/e0568509-996e-412c-ae91-fbd126a10a35" />

When I originally created the server within Hyper-V, I did not partition the drive correctly, which was fixed by going into Disk Management and shrinking the main partition, and then creating a new simple volume.

<img width="1020" height="761" alt="Screenshot 2026-01-24 124441" src="https://github.com/user-attachments/assets/57454c5c-e276-4ff7-b2d3-5bed93c35636" />

I then structured folders within a folder named "Share" like so.

<img width="1018" height="761" alt="Screenshot 2026-01-24 124730" src="https://github.com/user-attachments/assets/ae427b37-58f2-432e-8336-99f998058b2d" />

Then within the share permissions, I added the local security groups from each department. You can configure this however you need depending on your security standards.

<img width="1019" height="762" alt="Screenshot 2026-01-24 125503" src="https://github.com/user-attachments/assets/c408af55-eb85-4beb-8f02-2ca3eeba1778" />

Within security settings, I also added the local security groups as well and configured permissions so that they could read and write and modify the folder. Again, this may vary depending on the company/organization that you work for.

<img width="1018" height="765" alt="Screenshot 2026-01-24 125725" src="https://github.com/user-attachments/assets/5dfcbf75-dd08-466b-8c84-aa5095d5b870" />

We can then test to see if our configuration works. For this example I am logged in under John Smith, one of the users that is part of the HR department.

<img width="449" height="74" alt="Screenshot 2026-01-24 130355" src="https://github.com/user-attachments/assets/224d5c5d-446b-46d7-9670-c5fc0f5f1eba" />

If we type in "\\FS01\HR" we get a valid connection to our folder.

<img width="1023" height="762" alt="Screenshot 2026-01-24 130439" src="https://github.com/user-attachments/assets/79f7fc1e-35e9-4c25-96d0-406c3fb39c01" />

But if we try to access another department's folder, let's say IT in this example, we get something different.

<img width="1018" height="763" alt="Screenshot 2026-01-24 130514" src="https://github.com/user-attachments/assets/668a5f29-25c3-469d-bc95-9bfeb59a2757" />

This is good because it means that we can not access a folder we're not supposed to have access to. We can further configure this though. We do not want users to have to type in the locations of folders in file explorer, infact, we want them to already have it mapped as a drive. In order to do this we will need to configure group policy. Over on the domain controller, we can open group policy management and select a department and create/link a gpo to that OU.

<img width="1022" height="767" alt="Screenshot 2026-01-24 131541" src="https://github.com/user-attachments/assets/995fbca7-dcac-486a-90c4-8f23530afee3" />

For this example we can name it "Map - HR Drive (H:)".

<img width="1024" height="760" alt="Screenshot 2026-01-24 131618" src="https://github.com/user-attachments/assets/d6ab579a-1077-4c0d-bdf5-dba0f556e009" />

Then within that GPO, if we go into "User Configuration" -> "Preferences" -> "Windows Settings" -> "Drive Maps", we can map a new drive.

<img width="1020" height="765" alt="Screenshot 2026-01-24 131653" src="https://github.com/user-attachments/assets/a915e43b-66f6-4a34-b088-198048e8b4b4" />

We can open up the "New Drive Properties" menu, select our action as "Create", specify the location of the folder we want to map as a drive, label it as "HR", and select our chosen drive letter.

<img width="830" height="592" alt="Screenshot 2026-01-24 131922" src="https://github.com/user-attachments/assets/d92093fb-bd34-4a9b-9058-fb060252c8b6" />

Then we will go into the "Common" tab, and check "Item level targeting". We will then hit the "Targeting..." button.

<img width="1017" height="762" alt="Screenshot 2026-01-24 132005" src="https://github.com/user-attachments/assets/4c66d1e8-305e-4a00-9d10-4b92351de4a1" />

Underneath here we will hit "New Item", and "Security Group".

<img width="1018" height="755" alt="Screenshot 2026-01-24 132017" src="https://github.com/user-attachments/assets/8d39fe91-f448-4c81-82fe-26d29b617125" />

All we have to do here is specify the group and make sure that "User in Group" is selected.

<img width="1015" height="768" alt="Screenshot 2026-01-24 132101" src="https://github.com/user-attachments/assets/1189c49a-2c5e-47c5-ab3c-818bf433e8f2" />

We can test if this works by logging on again as a user within that group and opening up the file explorer. If this is configured correctly then your new mapped drive should show!

<img width="1017" height="765" alt="Screenshot 2026-01-24 132647" src="https://github.com/user-attachments/assets/2be276f1-5f4f-481d-ab0d-d62e22bd67a4" />

## Deploying MSI Software via GPO
One of the things we might want to do in our organization is have the ability to mass deploy software for our employees. Most organizations have some sort of software that everybody uses, whether that be Teams, Adobe, etc.. We can easily configure this through Group Policy. First we'll create a new domain local security group named "Software_Install". In a real world scenario you might want to be more specific with this, but for lab purposes this is what we will leave it as.

<img width="1020" height="762" alt="Screenshot 2026-01-27 133638" src="https://github.com/user-attachments/assets/7fce2e50-f1d1-47f6-a306-38bb719cad06" />

We have also created another global group known as "IT_Computers". We have selected our VM and made sure that it is a member of this group.

<img width="1020" height="766" alt="Screenshot 2026-01-27 141119" src="https://github.com/user-attachments/assets/cd4a6a52-39bc-4034-8b1d-bf35526d1d24" />

Over on our file server, we will need to create a folder that we are going to name "Software$". The "$" will ensure that this folder remains hidden. You will need to place the MSI file of your choice within this share folder. I have already done that. We will add our new domain local group to this share, and ensure that we remove "everyone" from the sharing tab in the folder's properties. We will also add our new domain local group within "security".

<img width="1021" height="761" alt="Screenshot 2026-01-27 133946" src="https://github.com/user-attachments/assets/f1a9a15e-8e8b-47e9-8db4-38fef25833ef" />

After this, we will open up group policy management on our domain and create a new policy underneath "LAB_Enterprises". The name for this policy is going to be "Software_Install".

<img width="1021" height="765" alt="Screenshot 2026-01-27 134307" src="https://github.com/user-attachments/assets/d91139e7-1481-4c72-9e0e-5018b98d3619" />

We can then navigate to "Computer Configuration" -> "Policies" -> "Software Settings" -> "Software Installation".

<img width="1020" height="758" alt="Screenshot 2026-01-27 134351" src="https://github.com/user-attachments/assets/0d1659bc-2428-4366-92c5-0a7737036932" />

We'll right click and select "New", then navigate to our folder on our file server. The path for this will be "\\192.168.10.15\Software$". We will then select the MSI file we want to install.

<img width="1021" height="763" alt="Screenshot 2026-01-27 134423" src="https://github.com/user-attachments/assets/cc4513f0-42b6-4a98-9bca-96b9dc8feefa" />

We will keep it as "Assigned", and then hit ok.

<img width="1018" height="765" alt="Screenshot 2026-01-27 134443" src="https://github.com/user-attachments/assets/0fde8822-e847-425d-8fa0-cf08ab4d7842" />

Then we will right click on our installer, and navigate to it's properties. Underneath "Deployment", we will select to "Uninstall this application when it falls out of the scope of management." This will uninstall the application if the computer one day no longer becomes managed by us. Hit "Apply" and then "OK".

<img width="1018" height="766" alt="Screenshot 2026-01-27 134533" src="https://github.com/user-attachments/assets/2c98a644-f28d-4908-8521-3ae620977e79" />

We can test our configuration by logging onto that computer. Run a "gpupdate /force" and it will run through some dialogue before asking us if we want to restart. We will type "y" here for yes and it will reboot the machine. 

<img width="1020" height="767" alt="Screenshot 2026-01-27 135518" src="https://github.com/user-attachments/assets/35ee0759-8395-4879-93ce-3e965fa02b61" />

When it reboots, log back in. As we can see, when the sign in process completes, the teams loader pops up on the screen. This means that our configuration works as intended!

<img width="1022" height="760" alt="Screenshot 2026-01-27 141030" src="https://github.com/user-attachments/assets/5c3656be-d447-4997-9932-9784b13250d5" />

## Loopback Processing
Loopback processing is a tool that can feel pretty confusing until you understand why it exists. To put it simply, loopback processing is used when the computer's role matters more than the user's. What does that exactly mean? Well, say for example you have a computer functioning as a kiosk, a dedicated machine that you want to be locked down and run a limited set of applications on for a specific purpose. An easy way to accomplish this is to use loopback processing. Normally, user GPOs apply based on where the account lives in AD, and computer GPOs apply based on where the computer lives. Loopback processing flips this logic on its head so that user settings are determined by the computer they log into. Let's dive into setting this up. I have already created a kiosk vm that we will use for example purposes. The first thing that I want to do is create a new OU, which we will place in the Sales OU, that will hold this new computer within it.

<img width="953" height="528" alt="Screenshot 2026-01-27 202503" src="https://github.com/user-attachments/assets/876d372c-882e-4491-933e-84fc6d343aa6" />

Inside group policy management, we will then create a new policy named "Loopback Processing" and link it to the Kiosk_PC OU.

<img width="1018" height="764" alt="Screenshot 2026-01-27 202603" src="https://github.com/user-attachments/assets/fa1781d8-163e-4382-b118-9e8582668ea3" />

Within the group policy management editor, we can navigate to "Computer Configuration" -> "Policies" -> "Administrative Templates" -> "System" -> "Group Policy" -> "Configure user Group Policy loopback processing mode".

<img width="1022" height="765" alt="Screenshot 2026-01-27 202707" src="https://github.com/user-attachments/assets/dc70b79b-5460-4245-9851-851747d84065" />

We will then select "Enable" and be shown two options, "Merge" and "Replace". In merge mode, a user's normal User GPOs apply first and then computer-linked GPOs are added on top. The computer GPO always wins if there is a conflict. You can think of it as "User policies + extra rules because of the computer". You'll want to use this when you want users to keep most of their normal experience but need extra restrictions on specific machines. Merge mode is useful for things like a shared office computer. In replace mode, the normal user GPOs are ignored completely and only the user settings from GPOs linked to the computer's OU apply. This is useful when you need tight control and locked down behavior on a system that needs to serve a specific purpose, like our kiosk machine. Replace is the option we will be choosing.

<img width="1020" height="761" alt="Screenshot 2026-01-27 202755" src="https://github.com/user-attachments/assets/ef3c069e-1e5a-4f7e-a868-5eb818ee5992" />

Because this is a lab and we are just testing to see if this works the way we want it to, we aren't going to configure many settings around this. What we will do is prohibit access to the control panel through the same GPO that we are in.

<img width="1020" height="765" alt="Screenshot 2026-01-27 202917" src="https://github.com/user-attachments/assets/691688c9-abbc-43a5-9374-c842a484a255" />

We will then log on to our kiosk machine as Hayley Williams, a user within our Sales department.

<img width="290" height="62" alt="Screenshot 2026-01-27 203401" src="https://github.com/user-attachments/assets/9ef37a02-d9f1-434b-87fe-afc9f83cbfd4" />

As we can see, upon trying to open up the control panel we get a notification that this has been cancelled due to restrictions on the machine.

<img width="977" height="712" alt="Screenshot 2026-01-27 203412" src="https://github.com/user-attachments/assets/401de7a3-ffbd-4bfb-912b-ac42c705bd33" />

But what if we log on as an administrator?

<img width="306" height="68" alt="Screenshot 2026-01-27 203601" src="https://github.com/user-attachments/assets/63bc8f45-ead4-4e02-a5c8-c18173c20443" />

Will we then be able to configure settings within the control panel now?

<img width="1020" height="765" alt="Screenshot 2026-01-27 203610" src="https://github.com/user-attachments/assets/54d3794c-12c6-4e67-890d-106e3f01b4f6" />

The answer to that is no. Because of loopback processing, the machine protects itself even from administrators. This effectively can lock down a computer to be used for a specific purpose, such as a kiosk, lab machine, school computer, etc.. Depending on the goals of specific machines within your organization, you may find this as a very useful tool.
















