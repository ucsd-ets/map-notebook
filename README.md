# Jupyter Notebook for Mentor Assistance Program

https://education.sdsc.edu/studenttech/map-home/

## Starting label-studio

Open a new terminal and run:

```
mamba init
source ~/.bashrc
mamba activate /opt/conda/envs/label-studio
export LABEL_STUDIO_HOST=https://datahub.ucsd.edu/user/$USER/proxy/8080
label-studio start
```

Then access it at http://datahub.ucsd.edu/hub/user-redirect/proxy/8080

## How to reset DB

```
rm -rf ~/.local/share/label-studio/
rm -rf ~/.config/label-studio
```

## Ultralytics

Select a notebook with a GPU to use CUDA hardware acceleration.

**Sample code**

```
from ultralytics import YOLO

# Create a new YOLO model from scratch
model = YOLO("yolo26n.yaml")

# Load a pretrained YOLO model (recommended for training)
model = YOLO("yolo26n.pt")

# Train the model using the 'coco8.yaml' dataset for 3 epochs
results = model.train(data="coco8.yaml", epochs=3)

# Evaluate the model's performance on the validation set
results = model.val()

# Perform object detection on an image using the model
results = model("https://ultralytics.com/images/bus.jpg")

# Export the model to ONNX format
success = model.export(format="onnx")
```
