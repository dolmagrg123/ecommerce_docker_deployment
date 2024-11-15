
# CI/CD DevSecOps Pipeline

Welcome to the CI/CD DevSecOps Pipeline! In the last workload, you were introduced to an environment where you had to identify vulnerabilities—finding weak spots and considering how they might impact production. Now, we’re taking things a step further: this time, you'll be deploying a DevOps CI/CD pipeline, but with a twist. Your goal is to make it a DevSecOps pipeline, embedding security into each stage from the very beginning.

As you go through the setup, remember to treat each tool as its own step in the CI/CD process. For each one, document what the tool does and why it’s crucial to the pipeline, building security right into the workflow.

## Prerequisites
Ensure the following are set up in your environment:
- **Docker** installed.
- **Python 3-venv** installed.

---

## Tools Overview

For each tool, write a brief explanation covering the following:
- What the tool does.
- Why you are using it in the CI/CD pipeline.

1. **Trivy** 
2. **SonarQube** 
3. **OWASP ZAP** (Install after you have install Jenkins)
4. **Checkov**

---

## Installation and Configuration

### 1. Trivy Installation

1. **Install Trivy** by following the [official installation documentation](https://aquasecurity.github.io/trivy/v0.18.3/installation/):
   ```bash
   sudo apt-get install wget apt-transport-https gnupg lsb-release
   wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
   echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
   sudo apt-get update
   sudo apt-get install trivy
   ```
2. **Output Storage**: Ensure that [Trivy scan](https://aquasecurity.github.io/trivy/v0.18.3/) outputs are saved in a `reports` directory of your CI/CD pipeline workspace (e.g., `/var/lib/jenkins_home/workspace/<your-pipeline-name>/reports/**trivy_report.json**`).

---

### 2. SonarQube Installation

#### Part 1: SonarQube Installation with Docker
1. **Run SonarQube in Docker**:
   ```bash
   docker run -d --name sonarqube -p 9000:9000 sonarqube:latest
   ```

2. **Access SonarQube**:
   - In your browser, go to `http://<your-ec2-public-ip>:9000`.
   - **Default Credentials**:
     - **Username**: `admin`
     - **Password**: `admin`
   - Change the default password upon your first login.

#### Part 2: Generate a SonarQube Token for Jenkins Integration
1. **Generate a SonarQube Token**:
   - In SonarQube, navigate to **Administration > Security > Users**.
   - Select your user (likely **admin**) and go to the **Tokens** tab.
   - Click **Generate Token**.
   - Name the token (e.g., `JenkinsToken`).
   - Copy the token—you’ll use it in Jenkins shortly.

#### Part 3: Integrate SonarQube with Jenkins
1. **Install SonarQube Scanner Plugin in Jenkins**:
   - Open Jenkins and go to **Manage Jenkins > Manage Plugins**.
   - In the **Available** tab, search for **SonarQube Scanner** and install it.
   - Restart Jenkins if prompted.

2. **Add SonarQube Server in Jenkins**:
   - Go to **Manage Jenkins > Configure System**.
   - Scroll down to **SonarQube servers**.
   - Click **Add SonarQube** and fill in the details:
     - **Name**: Enter a descriptive name, like `SonarQubeServer`.
     - **Server URL**: Enter `http://<your-ec2-public-ip>:9000`.
     - **Server Authentication Token**: Click **Add** to create a new secret text credential.
       - **Kind**: Secret text
       - **Secret**: Paste the SonarQube token you created earlier.
       - **ID**: Enter a unique ID, such as `sonar-token`.

3. **Configure SonarQube Scanner in Jenkins**:
   - Go to **Manage Jenkins > Global Tool Configuration**.
   - Scroll down to **SonarQube Scanner**.
   - Click **Add SonarQube Scanner** and provide a name, such as `SonarScanner`.
   - Check **Install automatically** and choose the default version.

---

### 3. OWASP ZAP
OWASP ZAP helps with dynamic security testing for web applications. **It must be run in headless mode** to enable seamless integration into the CI/CD pipeline without a graphical interface.

1. **Install OWASP ZAP** in **headless mode** for scanning web applications.
   ```bash
   wget https://github.com/zaproxy/zaproxy/releases/download/v2.15.0/ZAP_2_15_0_unix.sh -O zap_install.sh
   chmod +x zap_install.sh
   sudo ./zap_install.sh -q -dir /opt/zap
   ```

2. **Output Storage**: Ensure that OWASP ZAP scan results are saved in the `reports` directory of your pipeline workspace (e.g., `/var/lib/jenkins_home/workspace/<your-pipeline-name>/reports/**zap_scan_results.json**`).

---

### 4. Checkov Setup 
1. **Set up Python Environment**:
   - Create a Python virtual environment for Checkov.

2. **Install Checkov**:
   - Install Checkov within the virtual environment.

3. **Output Storage**: Ensure that Checkov scan outputs are saved in the `reports` directory of your pipeline workspace (e.g., `/var/lib/jenkins_home/workspace/<your-pipeline-name>/reports/**checkov_report.json**`).
