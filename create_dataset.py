#!/bin/env python3

import csv
import cv2
import numpy as np
from os.path import join
from os import listdir
from PIL import Image


CLASSIFIER_PATH="/usr/share/opencv4/haarcascades/haarcascade_frontalface_default.xml"
DS_FOLDER = "out"
MIN_NEIGHBORS = 5
SCALE_FACTOR = 1.05

HEADERS = ["Filename", "Width", "Height", "Roi.X1", "Roi.Y1", "Roi.X2", "Roi.Y2", "ClassId"]

cf = cv2.CascadeClassifier(CLASSIFIER_PATH)


def classify(image):
    gray = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2GRAY)
    b = cf.detectMultiScale(gray, SCALE_FACTOR, MIN_NEIGHBORS)
    return b[0]

def gen_row(dname, fname, w, h, box):
    class_id = dname.replace("0", "")
    return [
        fname, w, h,
        b[0], b[1], b[2], b[3],
        class_id
    ]


for d in listdir(DS_FOLDER):
    path = join(DS_FOLDER, d)
    csv_file = join(path, f"GT-{d}.csv")
    with open(csv_file, mode='w') as csv_f:
        w = csv.writer(csv_f, delimiter=",")
        w.writerow(HEADERS)
        for image_file in listdir(path):
            if not image_file.endswith(".ppm"):
                continue    
            image = Image.open(join(path, image_file))
            b = classify(image)
            print(gen_row(d, image_file, image.width, image.height, b))
            w.writerow(gen_row(d, image_file, image.width, image.height, b))

