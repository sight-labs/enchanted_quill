class UIGestureRecognizerDelegate
  def gestureRecognizer(gesture_recognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer: other_gesture_recognizer)
    true
  end

  def gestureRecognizer(gesture_recognizer, shouldRequireFailureOfGestureRecognizer: other_gesture_recognizer)
    true
  end

  def gestureRecognizer(gesture_recognizer, shouldBeRequiredToFailByGestureRecognizer: other_gesture_recognizer)
    true
  end
end
