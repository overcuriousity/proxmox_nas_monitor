# proxmox_nas_monitor

Shuts down containers/vms if mounted NAS is down.

I am shutting down my NAS over night. Because it is mounted on various containers doing db transactions all the time, they went crazy in terms of errors ad SWAP usage.

So my idea was to solve this issue by using a script for

1. check if the NAS is up
2. shut down the ct´s if not
3. or start them if they are stopped and NAS is up

and add the script to a cron job:

     ```bash
     crontab -e
     ```
and paste 

     ```bash
     */10 * * * * /path/to/nas_monitor.sh
     ```
