<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Node Runner Dogecoin Node Docker Setup</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 text-gray-900 font-sans leading-normal">
    <div class="container mx-auto p-4">
        <div class="bg-white rounded shadow-md p-6">
            <img src="/Users/Book/Documents/GitHub/NodeRunnerDocker/logo/DoginalSupportDesk.jpg" alt="Doginal Support Desk" class="w-full h-auto mb-4 rounded">
            <h1 class="text-4xl font-bold mb-4">Dogecoin Node Docker Setup</h1>

            <section class="mb-6">
                <h2 class="text-2xl font-semibold mb-2">Overview</h2>
                <p>This setup provides a Docker container that installs and configures a Dogecoin node, along with several utilities, and resumes installation even after a system restart. The container will detect the operating system and install the Dogecoin node accordingly.</p>
            </section>

            <section class="mb-6">
                <h2 class="text-2xl font-semibold mb-2">Prerequisites</h2>
                <ul class="list-disc list-inside">
                    <li>Docker</li>
                    <li>Docker Compose</li>
                </ul>
            </section>

            <section class="mb-6">
                <h3 class="text-xl font-semibold mb-2">What is Docker?</h3>
                <p>Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all parts it needs, such as libraries and other dependencies, and ship it all out as one package.</p>
            </section>

            <section class="mb-6">
                <h3 class="text-xl font-semibold mb-2">What is Docker Compose?</h3>
                <p>Docker Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services. Then, with a single command, you create and start all the services from your configuration.</p>
            </section>

            <section class="mb-6">
                <h2 class="text-2xl font-semibold mb-2">Instructions</h2>
                <h3 class="text-xl font-semibold mb-2">Step 1: Install Docker and Docker Compose</h3>

                <h4 class="text-lg font-semibold mb-2">For Windows and Mac:</h4>
                <ol class="list-decimal list-inside mb-4">
                    <li>Download Docker Desktop from <a href="https://www.docker.com/products/docker-desktop" class="text-blue-600">Docker's official website</a>.</li>
                    <li>Follow the installation instructions for your operating system.</li>
                    <li>Once installed, Docker and Docker Compose come bundled together.</li>
                </ol>

                <h4 class="text-lg font-semibold mb-2">For Linux:</h4>
                <pre class="bg-gray-200 p-4 rounded mb-4">
<code class="language-sh">
sudo apt-get update
sudo apt-get install \\
    apt-transport-https \\
    ca-certificates \\
    curl \\
    gnupg \\
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \\
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \\
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
</code>
                </pre>

                <h4 class="text-lg font-semibold mb-2">Install Docker Compose:</h4>
                <pre class="bg-gray-200 p-4 rounded mb-4">
<code class="language-sh">
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
</code>
                </pre>

                <h4 class="text-lg font-semibold mb-2">Verify the installation:</h4>
                <pre class="bg-gray-200 p-4 rounded mb-4">
<code class="language-sh">
docker --version
docker-compose --version
</code>
                </pre>
            </section>

            <section class="mb-6">
                <h3 class="text-xl font-semibold mb-2">Step 2: Clone the Repository</h3>
                <pre class="bg-gray-200 p-4 rounded mb-4">
<code class="language-sh">
git clone https://github.com/yourusername/dogecoin-node-setup.git
cd dogecoin-node-setup
</code>
                </pre>
            </section>

            <section class="mb-6">
                <h3 class="text-xl font-semibold mb-2">Step 3: Build the Docker Image</h3>
                <pre class="bg-gray-200 p-4 rounded mb-4">
<code class="language-sh">
docker build -t dogecoin-node .
</code>
                </pre>
            </section>

            <section class="mb-6">
                <h3 class="text-xl font-semibold mb-2">Step 4: Run the Docker Container</h3>
                <pre class="bg-gray-200 p-4 rounded mb-4">
<code class="language-sh">
docker-compose up -d
</code>
                </pre>
            </section>

            <section class="mb-6">
                <h3 class="text-xl font-semibold mb-2">Step 5: Verify Dogecoin Node Status</h3>
                <pre class="bg-gray-200 p-4 rounded mb-4">
<code class="language-sh">
docker exec -it dogecoin_node dogecoin-cli getblockchaininfo
</code>
                </pre>
            </section>

            <section class="mb-6">
                <h2 class="text-2xl font-semibold mb-2">Utilities Included</h2>
                <ul class="list-disc list-inside mb-4">
                    <li>APE DUNES GUI</li>
                    <li>APE Image Converter</li>
                    <li>BC Auto Scripts</li>
                    <li>BC Snapshot</li>
                    <li>BCxHeim Recurse</li>
                    <li>BP MetaData Merger</li>
                    <li>BP TelegramBot</li>
                    <li>SirDuney DUNES</li>
                </ul>
            </section>

            <section class="mb-6">
                <h2 class="text-2xl font-semibold mb-2">Resuming Installation</h2>
                <p>If the Docker container is stopped or the system is restarted, the installation can be resumed by starting the container again:</p>
                <pre class="bg-gray-200 p-4 rounded mb-4">
<code class="language-sh">
docker-compose up -d
</code>
                </pre>
                <p>The state management script will ensure that the Dogecoin node starts and the installation resumes as needed.</p>
            </section>

            <section class="mb-6">
                <h2 class="text-2xl font-semibold mb-2">Adding Pictures</h2>
                <p>To add pictures, place your images in the appropriate directory and reference them in this README file as shown below:</p>
                <pre class="bg-gray-200 p-4 rounded mb-4">
<code class="language-markdown">
![Alt Text](path/to/image.png)
</code>
                </pre>
            </section>

            <section class="mb-6">
                <h2 class="text-2xl font-semibold mb-2">Troubleshooting</h2>
                <p>If you encounter any issues, check the logs for more details:</p>
                <pre class="bg-gray-200 p-4 rounded mb-4">
<code class="language-sh">
docker logs dogecoin_node
</code>
                </pre>
                <p>For further assistance, consult the documentation for Docker and Docker Compose.</p>
            </section>

            <p>This setup ensures a smooth installation and configuration of a Dogecoin node with additional utilities, while handling system restarts gracefully.</p>
        </div>
    </div>
</body>
</html>
