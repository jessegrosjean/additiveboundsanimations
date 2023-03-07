#  Additive Bounds Animations Test

Run the demo and you'll see two buttons.

1. Toggle Position: Toggle the rects position using additive animations. The nice feature is you can click the button fast and you still get smooth animations.

2. Toggle Bounds: Toggle the rects bounds using additive animations. This version has problems, in particular when it animates from small to larger it starts too big and then animates back to correct position. The part that confuses me is the presentation bounds printed in the console look correct, it's just the visuals that are wrong.

My questions: Is there a way to get case 2 working smoothly like case one?

