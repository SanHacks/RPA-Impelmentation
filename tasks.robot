*** Settings ***
Documentation       Orders robots from RobotSpareBin Industries Inc.

Library             RPA.Browser.Selenium    auto_close=${False}
Library             RPA.HTTP
Library             RPA.PDF
Library             RPA.Excel.Files
Library             RPA.Archive
Library             String
Library             RPA.Tables
Library             RPA.Desktop
Library             RPA.RobotLogListener
Library             RPA.JavaAccessBridge
Library             RPA.FileSystem
# The robot should use the orders file (.csv ) and complete all the orders in the file.
#Only the robot is allowed to get the orders file. You may not save the file manually on your computer.
# The robot should save each order HTML receipt as a PDF file.
# The robot should save a screenshot of each of the ordered robots.
# The robot should embed the screenshot of the robot to the PDF receipt.
#The robot should create a ZIP archive of the PDF receipts (one zip archive that contains all the PDF files). Store the archive in the output directory.
# The robot should complete all the orders even when there are technical failures with the robot order website.


*** Variables ***
${URL}                          https://robotsparebinindustries.com/orders.csv
${PDF_TEMP_OUTPUT_DIRECTORY}    ${CURDIR}${/}temp


*** Tasks ***
Orders robots form RobotSpareBin Industries Inc
    Set up directories
    Open the robot order website
    Read Worksheet from Excel File
    Fill the form using the data from the Excel file
    Create ZIP package from PDF files
    Cleanup temporary PDF directory


*** Keywords ***
Set up directories
    Create Directory    ${PDF_TEMP_OUTPUT_DIRECTORY}
    Create Directory    ${OUTPUT_DIR}

Open the robot order website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order
    Click Button When Visible    locator=//button[@class="btn btn-dark"]

Read Worksheet from Excel File
    Download    ${URL}    ${OUTPUT_DIR}${/}/orders.csv    overwrite=True

Fill and submit the form for one customer
    [Arguments]    ${row}
    Select From List By Value    head    ${row}[Head]
    Select Radio Button    body    ${row}[Body]
    Input Text    css=input.form-control[type=number][placeholder="Enter the part number for the legs"]    ${row}[Legs]
    Input Text    id:address    ${row}[Address]
    Click Button    id=preview
    Wait Until Page Contains Element    id:robot-preview-image    timeout=10s
    Screenshot    robot-preview    ${PDF_TEMP_OUTPUT_DIRECTORY}${/}${row}[Order number].png
    Click Button    id=order
    #alert alert-danger , if alert is visible, then the order is not complete , press order again
    ${alert}    Run Keyword And Continue On Failure    Get Element Attribute    css=div.alert.alert-danger    class
    IF    '${alert} == alert alert-danger'
        Run Keyword And Continue On Failure    Click Button    id=order
    ELSE
        Run Keyword And Continue On Failure    Click Button    id=order
    END
    Wait Until Page Contains Element    id:order-completion    timeout=10s
    ${order_to_html}    Get Element Attribute    id:order-completion    outerHTML
    Html To Pdf    ${order_to_html}    ${OUTPUT_DIR}${/}${row}[Order number].pdf    overwrite=True
    Add Watermark Image To Pdf
    ...    ${PDF_TEMP_OUTPUT_DIRECTORY}${/}${row}[Order number].png
    ...    ${OUTPUT_DIR}${/}${row}[Order number].pdf
    ...    ${OUTPUT_DIR}${/}${row}[Order number].pdf
    Click Button    locator=//button[@id="order-another"]
    Click Button When Visible    locator=//button[@class="btn btn-dark"]

Fill The Form Using The Data From The Excel File
    ${orders}    Read Table From CSV    ${OUTPUT_DIR}${/}/orders.csv    header=True
    Log    ${orders} rows read from orders.csv file
    FOR    ${row}    IN    @{orders}
        Run Keyword And Ignore Error    Fill and submit the form for one customer    ${row}
    END

Create ZIP package from PDF files
    ${zip_file_name}    Set Variable    ${OUTPUT_DIR}/PDFs.zip
    Archive Folder With Zip
    ...    ${OUTPUT_DIR}
    ...    ${zip_file_name}

Cleanup temporary PDF directory
    Remove Directory    ${PDF_TEMP_OUTPUT_DIRECTORY}    True
