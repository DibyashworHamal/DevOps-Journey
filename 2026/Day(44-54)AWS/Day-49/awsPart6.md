## Day 49: S3 Static Website Hosting, Bucket Policies & Intro to CloudWatch (May 21, 2026)

### 🗂️ 1. S3 Dashboard Deep Dive
Before deploying our website, we explored the advanced management tabs of an S3 Bucket:
- **Properties:** Bucket versioning, Static website hosting, and Event notifications.
- **Permissions:** Block public access settings, Bucket Policies (JSON), and CORS (Cross-Origin Resource Sharing).
- **Metrics:** Storage size and object count monitoring.
- **Management:** Lifecycle rules (moving old data to Glacier) and Replication rules (copying buckets to another AWS Region for disaster recovery).

### 🌐 2. Practical Lab: Serverless Static Website Hosting
We deployed a live HTML website using purely S3, requiring zero EC2 instances or web servers like Apache/Nginx!

**Step 1: Uploading the Application Files**
- Created a new S3 bucket.
- Uploaded our raw website files (`index.html`, CSS, JS).

**Step 2: Enabling the Hosting Feature**
- Navigated to **Properties** ➡️ **Static website hosting**.
- Clicked **Enable**.
- Specified the Index document: `index.html`.

**Step 3: Configuring Public Access & Bucket Policies**
By default, S3 blocks all public access to prevent data leaks. To host a public website, we had to carefully modify the security settings:
- Navigated to **Permissions** and *unchecked* **Block all public access**.
- Added a custom **Bucket Policy (JSON)** to grant read-only access (`s3:GetObject`) to the entire internet (`Principal: "*"`).

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-bucket-name/*"
        }
    ]
}
```
**Step 4: Verification**
- Grabbed the generated S3 Website Endpoint URL from the Properties tab.
- Browsed the URL and successfully saw the live website!

### 🛑 3. Handling 404 Errors (Custom Error Pages)
A professional website doesn't show a raw XML error when a user types a wrong URL.
- Uploaded a custom error.html file to the bucket.
- Updated the Static Website Hosting settings to specify error.html as the Error document.
- **Test:** Purposely typed a wrong URL (http://<s3-url>/fake-page.html) and watched S3 magically route the traffic to my custom 404 error page!

### 🗑️ 4. Resource Cleanup
Practicing strict FinOps, we emptied the bucket of all HTML files and deleted the bucket to ensure no lingering cloud costs.

### 👁️ 5. Introduction to AWS CloudWatch
Wrapped up the day discussing AWS's native monitoring service.
- **What it is:** The "eyes and ears" of AWS. It collects monitoring and operational data in the form of logs, metrics, and events.
- **Use Case:** Can be used to trigger Alarms (e.g., "Send me an email if EC2 CPU usage hits 90%").