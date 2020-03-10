# xkcd-style
Experiments with XKCD style in Matplotlib

## Docker support

### Prerequisites
You need to install the following software:
+ [Docker](https://docs.docker.com/install/)
+ [Docker Compose](https://docs.docker.com/compose/install/)

### Linux/MacOS

```
sudo chown -R 1000 /path/to/repo/xkcd-style
docker-compose up
```

### Windows
```
icacls * /reset /t /c /q /path/to/repo/xkcd-style
docker-compose up
```

### JupyterLab
Once your container is built and running, it will print a URL, like the following one http://127.0.0.1:8888/?token=1ac9f8f209fe5faeecc7ed68fdb68d0b047ba8847caea390, that you should open in your browser.

### Rebuilding your container
In case you need to add some new Python dependencies to your `environment.yml` file, you need to rebuild your container with:
```
docker-compose up --build
```

### Debugging
To add a breakpoint in your Python code insert the following line where you want your code to stop:
```
import wdb; wdb.set_trace()
```
Then open the following URL in your browser  http://localhost:1984/, and use the GUI to debug your code.