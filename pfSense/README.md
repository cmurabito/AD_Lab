# Configuring pfSense
At some point if you are following along with this lab you might want to implement a way for your client machines to have an internet connection. I chose pfSense for this solution. PfSense will allow our virtual machines to have an internet connection while keeping our lab network segmented from our home network. Setting this up is pretty easy. First we will want to create a new virtual machine within Hyper-V.

<img width="699" height="527" alt="Screenshot 2026-01-29 182900" src="https://github.com/user-attachments/assets/e3fd5c4a-51a5-4578-bad4-8513673a6596" />

PfSense only really needs about 1 Gb of memory to run, so that's what I entered, although 2 Gb is recommended and I ended up changing this later.

<img width="699" height="529" alt="Screenshot 2026-01-29 182939" src="https://github.com/user-attachments/assets/39afc9d8-acd0-4718-81d6-606c640fda1f" />

We're going to leave networking unconfigured at the moment.

<img width="696" height="530" alt="Screenshot 2026-01-29 182955" src="https://github.com/user-attachments/assets/127feac8-7b4a-46da-add3-7365145869de" />

We will also give pfSense 20Gb of virtual hard disk space.

<img width="698" height="529" alt="Screenshot 2026-01-29 183009" src="https://github.com/user-attachments/assets/893b85d7-86b3-44bb-b20f-b838e145155a" />

We're going to want to make sure that we have an external and an internal interface set up within Hyper-V. We have already set these up, but if you need a refresher you can find it in the main AD_Lab readme.

<img width="719" height="680" alt="Screenshot 2026-01-29 183108" src="https://github.com/user-attachments/assets/1925ca8e-5a5b-498c-9139-abe9a77fe7a1" />

Alright, here is where we need to do a bit of configuring. PfSense will naturally see the first ethernet adapter as the WAN, and the second ethernet adapter as the LAN. We will want to set our first ethernet adapter to connect to our external network, and our second to be connected to our internal network. We will also want to disable secure boot and set the boot order so that it boots from the hard drive, not the ISO that we downloaded. 

<img width="715" height="681" alt="Screenshot 2026-01-29 183310" src="https://github.com/user-attachments/assets/74843797-530a-4e69-9901-5f3e0f18ed06" />

We can now boot up pfSense for the first time. Go ahead and hit enter on the install page to begin the installation.

<img width="1012" height="767" alt="Screenshot 2026-01-29 183409" src="https://github.com/user-attachments/assets/9cc2eaa4-4719-47e2-8977-32ae80d66da9" />

We will hit next until we get to the partitioning, we will keep as is and hit enter.

<img width="1021" height="767" alt="Screenshot 2026-01-29 183433" src="https://github.com/user-attachments/assets/037b980d-a3b9-4d16-aeb6-9e58dcc0bc2b" />

Then we just keep hitting enter until we get to reboot. We will now reboot pfSense.

<img width="1019" height="766" alt="Screenshot 2026-01-29 183523" src="https://github.com/user-attachments/assets/ba044465-de40-475c-b1ea-a15a55e6fbf2" />

Upon reboot it will ask us if we want to set up VLANs. This is not part of what we are doing at the moment so we will type "n" and hit enter.

<img width="1020" height="763" alt="Screenshot 2026-01-29 184240" src="https://github.com/user-attachments/assets/0ddfede0-6808-42d3-857c-b294ca06bf54" />

It will then ask us the name of the WAN interface. You can check this by finding the mac address to verify, but since we set it up like we did it should be the first one listed, "hn0".

<img width="1020" height="760" alt="Screenshot 2026-01-29 184309" src="https://github.com/user-attachments/assets/4f0cd360-04c7-4aba-9ed7-7b78584bbd72" />

Then it will ask us for the LAN interface, we will type "hn1".

<img width="1023" height="766" alt="Screenshot 2026-01-29 184322" src="https://github.com/user-attachments/assets/2ad5458f-c001-480d-b76b-0bded65baa37" />

It then brings us into the menu. You will see that our LAN interface is currently "192.168.1.1/24". We are going to want to change this to "192.168.10.1" for our lab purposes. We will select "2" to change this, type "2" to select the LAN specifically, type "n" because we want pfSense to have a static IP, and type our new IP address in.

<img width="1024" height="765" alt="Screenshot 2026-01-29 184607" src="https://github.com/user-attachments/assets/130a793c-4fd3-4ac3-a086-3515ab2a78f5" />

We will type "24" into our next line because 255.255.255.0 is the subnet that we want to specify then hit enter. We will then hit enter on the next line because we are configuring the LAN, type "n" because we do not want to configure IPv6, hit enter on the line after that because we do not want to set an IPv6 address, and type "n" to specify that we do not want to enable DHCP on LAN because we want our windows server to handle DHCP. It will ask us about the web configurator reverting to http, type "y". This will allow us to configure the rest via the web panel.

<img width="1017" height="764" alt="Screenshot 2026-01-29 184734" src="https://github.com/user-attachments/assets/fd108bc7-f3b6-4c8e-b9f4-2c3d8d34ce0a" />

You will see something like this when it is finished. This will be the IP address that we type into our browser on our server to configure the rest. Hit enter and then leave it running and we will switch to our windows server.

<img width="1021" height="298" alt="Screenshot 2026-01-29 184755" src="https://github.com/user-attachments/assets/aed89f3d-ac4d-4dc0-b4f4-2e67482385f3" />

When we open our windows server, we'll open the browser and go to that IP address. We will be greeted with the pfSense login panel. The default for this is "admin" for the username and "pfsense" for the password.

<img width="1015" height="761" alt="Screenshot 2026-01-29 185031" src="https://github.com/user-attachments/assets/645cad09-68aa-45f0-82fa-8947150e8364" />

When you get to this screen, make sure you do not end the domain name with anything ".local". This will cause issues later down the line. Set the primary DNS server to the domain controller, and type in "8.8.8.8" as your secondary.

<img width="1023" height="694" alt="Screenshot 2026-01-29 185140" src="https://github.com/user-attachments/assets/12bd25ac-c538-4a18-8576-dd15aed341a8" />

Change time zone if you need to.

<img width="1019" height="766" alt="Screenshot 2026-01-29 185338" src="https://github.com/user-attachments/assets/d8ccdbdb-3bb3-449b-823e-339a0678af29" />

Leave this next screen as is.

<img width="1020" height="770" alt="Screenshot 2026-01-29 185401" src="https://github.com/user-attachments/assets/fa45e000-e020-4821-bb71-5adc98b52402" />

Now we can set a super secret secure password! :)

<img width="1020" height="763" alt="Screenshot 2026-01-29 185449" src="https://github.com/user-attachments/assets/3b196fff-b1ca-4b5d-ae70-b9b14b8d1d8c" />

PfSense should now be configured! All we need to do now is test it to make sure everything is functioning.

<img width="1019" height="763" alt="Screenshot 2026-01-29 185619" src="https://github.com/user-attachments/assets/1883cb36-49cd-4ff2-85a2-20082cc6f7d3" />

In order to test this, go into your domain controller's settings and make sure that it is pointing to pfsense as the default gateway and disable any other ethernet adapters.

<img width="1023" height="763" alt="Screenshot 2026-01-29 185816" src="https://github.com/user-attachments/assets/31fe7428-02f8-4784-bea6-a4c372bd18da" />

And voila! If we can browse, that means that its working.

<img width="1017" height="765" alt="Screenshot 2026-01-29 185937" src="https://github.com/user-attachments/assets/e99e8a5b-58f2-414a-be89-aa9ea8f26e83" />

We also need to test this on our client machines. If you don't get a connection, try an "ipconfig /release" and "ipconfig /renew" and make sure that the gateway is the IP you set it as. If you have something other than the IP you set listed as the default gateway, then you may need to check your dhcp scope on windows server and change that. Happy routing! :)
