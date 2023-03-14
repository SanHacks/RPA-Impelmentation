# Automated Order Submission and Storage
![image](https://user-images.githubusercontent.com/13138647/225052458-afa87a92-80ef-4d0b-abaf-6b1ead961fd6.png)

## Running the Robot Locally

- Get started from a simple task template in `tasks.robot`.
  - Uses [Robot Framework](https://robocorp.com/docs/languages-and-frameworks/robot-framework/basics) syntax.
- You can configure your robot `robot.yaml`.
- You can configure dependencies in `conda.yaml`.


## Running the Robot in the Cloud

- You can run the robot in the cloud by creating a [RPA Cloud](https://robocorp.com/docs/development-guide/rpa-cloud) account.
- You can configure your robot `robot.yaml` to run in the cloud.
- You can configure dependencies in `conda.yaml`.

## Objectives of the Robot Framework Project 
- [x] Only the robot is allowed to get the orders file. Without human intervention.
- [x] The robot saves each order HTML receipt as a PDF file. and saves it to the `output` folder.
- [x] The robot saves a screenshot of each of the ordered robots.
- [x] The robot embedds the screenshot of the robot to the PDF receipt.
- [x] The robot creates a ZIP archive of the PDF receipts (one zip archive that contains all the PDF files). Store the archive in the output directory.
- [x] The robot completes all the orders even when there are technical failures with the robot order website.
<!-- - [x] The robot is available in public GitHub repository.
- [x] The robot can be downloaded from the public GitHub repository and run it without manual setup. -->