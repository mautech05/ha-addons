## About the original Project

---

[Kopia](https://kopia.io/) creates snapshots of the files and directories you designate, then encrypts these snapshots before they leave your computer, and finally uploads these encrypted snapshots to cloud/network/local storage called a repository. Snapshots are maintained as a set of historical point-in-time records based on policies that you define.

Kopia uses content-addressable storage for snapshots, which has many benefits:
- Each snapshot is always incremental. This means that all data is uploaded once to the repository based on file content, and a file is only re-uploaded to the repository if the file is modified. Kopia uses file splitting based on rolling hash, which allows efficient handling of changes to very large files: any file that gets modified is efficiently snapshotted by only uploading the changed parts and not the entire file.
- Multiple copies of the same file will be stored once. This is known as deduplication and saves you a lot of storage space (i.e., saves you money).
- After moving or renaming even large files, Kopia can recognize that they have the same content and won’t need to upload them again.
- Multiple users or computers can share the same repository: if different users have the same files, the files are uploaded only once as Kopia deduplicates content across the entire repository.

## About this add-on

---

### 📦Installation Guide
1. Add my repository to your home assistant instance

   [![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fmautech05%2Fha-addons)
1. Install this add-on.
1. Go to the *settings* tab and set your passwords. It is ok if both are the same.
1. Start this add-on.
1. Check the add-on logs to see if everything went well.
1. Open the webUI and connect to or create your first repository.

> ⚠️**ATTENTION:** When creating your Kopia repository, make sure to enter the same password you typed in the 'repo_password' field of the configuration tab. This is very important for everything to work correctly.

### 💻Accessing the WebUI
The WebUI can be found at [http://[your_home_assistant_instance_url]:[PORT]]()
(where [PORT] is the one you defined in the *settings* tab.)

~~This add-on's login should be managed by Ingress but, if ever asked for any credentials,~~ these are the default values:
- Default user: `kopia`
- Default password: `homeassistant`

The default user cannot be changed. As for the password, it is overwritten with anything found in the webui_password field in the *settings* tab.

### 🚫WebUI Limitations
Currently, for the Docker version, there is no way to create or manage multiple repositories at the same time using the web interface. The only way is using the [command line interface](https://kopia.io/docs/reference/command-line/common/#commands-to-manipulate-repository).

### 📂HA Directories mounted
This add-on is configured to have access to the following folders:
- share
- media
- ssl

You may connect to or create a Kopia Repository anywhere inside those locations. You may also connect to an offsite/cloud Kopia Repository to backup any data inside those locations. To do so, simply use the next sintaxis when asked for it:
- `/share/[random/folder/structure/]`
- `/media/[random/folder/structure/]`