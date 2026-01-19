# 1. List available emulators
  ~/Library/Android/sdk/emulator/emulator -list-avds

  # 2. Start emulator (replace with your AVD name)
  ~/Library/Android/sdk/emulator/emulator -avd <AVD_NAME> &

  # 3. Wait for emulator to boot, then run app
  /Users/subhas/Work/flutter/bin/flutter run -d emulator-5554

  Or as a single flow:

  # Start emulator in background and run app
  ~/Library/Android/sdk/emulator/emulator -avd Pixel_8_Pro_API_35 &
  sleep 30 && /Users/subhas/Work/flutter/bin/flutter run -d
  emulator-5554

  Quick check devices:
  /Users/subhas/Work/flutter/bin/flutter devices



  Ad units - 
  App open - ca-app-pub-2063094445044192/3844172313
  Reward - ca-app-pub-2063094445044192/6676373300
  Banner - ca-app-pub-2063094445044192/6470335653