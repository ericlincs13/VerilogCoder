import inspect


def debug_logger(content):
    current_frame = inspect.currentframe()
    if current_frame is None or current_frame.f_back is None:
        print(">>>>>")
        print(content)
        print("<<<<<")
    else:
        caller_frame = current_frame.f_back
        frame_info = inspect.getframeinfo(caller_frame)
        file_path = frame_info.filename
        line_number = frame_info.lineno
        print(f">>>>> {file_path} : {line_number}")
        print(content)
        print("<<<<<")
