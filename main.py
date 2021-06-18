import subprocess

print("Got subprocess import.")
print("Running slicer.")

# run a test slicing program
# app (containing the python app) is the directory when run
subprocess.run("cd .. && cd /ZengerEngine/build && "
    "wget https://raw.githubusercontent.com/Ultimaker/Cura/4.10/resources/definitions/fdmprinter.def.json && "
    "wget https://raw.githubusercontent.com/Ultimaker/Cura/4.10/resources/definitions/fdmextruder.def.json && "
    "wget https://raw.githubusercontent.com/Ultimaker/Cura/4.10/resources/definitions/prusa_i3.def.json && "
    "wget https://raw.githubusercontent.com/KrisRoofe/curaengine-dockerfile/master/herringbone-gear-large.stl && "
    "./CuraEngine slice -p -j ./fdmprinter.def.json -j prusa_i3.def.json -l herringbone-gear-large.stl -o herringbone-gear-large.gcode"
    , shell=True)

print("Slicer run.")