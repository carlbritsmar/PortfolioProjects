import os, shutil

path = r"/Users/calle/Desktop/Pythonproject" #Defining path using r to interpret the string as literal to avoid newline for example.
files = os.listdir(path) #list directories in path
print(files)


folder_names = ["csv files","image files", "text files"] #creating names for folders


for loop in range(len(folder_names)): #loop which checks if folders exists if not it will create it via folder_names list
    full_path = os.path.join(path, folder_names[loop])
    if not os.path.exists(full_path):
        os.makedirs(full_path)
        print("Folder created", full_path)

for file in files:
    if ".csv" in file:
        source = os.path.join(path, file)
        destination_csv = os.path.join(path, "csv files")
        if not os.path.exists(path + "csv files/" + file):
            shutil.move(source, destination_csv)

    elif ".webp" in file or ".jpg" in file:
        source = os.path.join(path, file)
        destination_image = os.path.join(path, "image files")
        if not os.path.exists(path + "image files/" + file):
            shutil.move(source,destination_image)

    elif ".docx" in file or ".pdf" in file:
        source = os.path.join(path, file)
        destination_text = os.path.join(path, "text files")
        if not os.path.exists(path + "text files/" + file):
            shutil.move(source, destination_text)

    






