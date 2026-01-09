# AD_Lab
The purpose of this repository is to document my progress towards mastering Active Directory and Windows Server. Hyper-V will be used as the hypervisor of choice during this process. I will be updating my progress below.

# Documentation
## Network Diagram
For this lab setup we are going to be connecting our domain controller to the external internet as well as running an internal network for our client VM on Hyper-V. This will change eventually and we will be adding another server.

<img width="121" height="461" alt="Network Diagram drawio" src="https://github.com/user-attachments/assets/5cfde644-8b42-4306-917a-df89344c47ca" />

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

<img width="1359" height="863" alt="Screenshot 2025-12-22 104256" src="https://github.com/user-attachments/assets/db15b98c-ac35-453f-9cbb-a093c99dd30b" />

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






