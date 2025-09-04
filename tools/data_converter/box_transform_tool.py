from scipy.spatial.transform import Rotation as R
from typing import Dict, Tuple, Any, List, Callable, Union
from pyquaternion import Quaternion
import numpy as np
import torch
import copy
from matplotlib.axes import Axes

def limit_period(val, offset=0.5, period=np.pi):
    """Limit the value into a period for periodic function.

    Args:
        val (torch.Tensor | np.ndarray): The value to be converted.
        offset (float, optional): Offset to set the value range.
            Defaults to 0.5.
        period ([type], optional): Period of the value. Defaults to np.pi.

    Returns:
        (torch.Tensor | np.ndarray): Value in the range of
            [-offset * period, (1-offset) * period]
    """
    if isinstance(val, torch.Tensor):
        limited_val = val - torch.floor(val / period + offset) * period
    elif isinstance(val, np.ndarray) or np.isscalar(val):
        limited_val = val - np.floor(val / period + offset) * period
    else:
        raise TypeError(f"input data type not adaptive: {type(val)}, please use a tensor or ndarray")
    
    return limited_val


def get_new_boxes3d(boxes3d):
    """change the camera output 3d box to adapt mmdet3dv1.0"""
    # deep clone
    new_boxes3d = boxes3d.clone()  

    original_3 = boxes3d[:, 3].clone()  
    original_4 = boxes3d[:, 4].clone()  
    
    new_boxes3d[:, 3] = original_4 
    new_boxes3d[:, 4] = original_3 
    new_boxes3d[:, 6] = -(new_boxes3d[:, 6] + np.pi/2)
    
    return new_boxes3d
