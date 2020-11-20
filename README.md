# OC/CC
a small repo for OpenComputers and ComputerCraft programs, both of which are mods that add programming to Minecraft in the form of the scripting language Lua

# Bank (OC)
a bank program to be ran on a OpenComputers server, the goal of this program is to provide utility to a minecraft servers society, it aims to fill the problems with fiate currencies such as gold ingots or dianmonds.

### Clients can:
* check an accounts balance
* list accounts
* balance leaderboards
* send funds

### Bank Owners can:
* add/remove accounts

### Server:
* inflate the economy
* loading and saving of accounts from txt file
* packets sent to the server are type checked as to prevent the program from crashing upon invalid input

the original version of this program had more features such as a frontend client side program to go with it, although the old server side code wasnt very clean so I decided to upload this version instead

# Mine (OC)
this program is a defuse **ressistant** mine. Some of its prevetative measures include
* exploding if any of the motion detectors are set off
* exploding if any connected compontents are destroyed
* remotly detonating if it recieves the proper message on a given port
