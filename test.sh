PRODUCT_NAME="${{ inputs.product }}"

if ! $(xcrun --find docc) process-archive \
      transform-for-static-hosting .build/docbuild/Build/Products/$DEBUG_PATH/$TARGET.doccarchive \
      --output-path .build/docs-$PLATFORM \
      --hosting-base-path "$TARGET"; then
        echo "Failed to transform documentation for $PLATFORM"
        return 1
    fi
    
- name: Build iOS
    run: xcodebuild -scheme "$PRODUCT_NAME" -derivedDataPath .build -destination 'generic/platform=iOS';
- name: Build macOS
    run: xcodebuild -scheme "$PRODUCT_NAME" -derivedDataPath .build -destination 'generic/platform=OS X';
- name: Build tvOS
    run: xcodebuild -scheme "$PRODUCT_NAME" -derivedDataPath .build -destination 'generic/platform=tvOS';
- name: Build watchOS
    run: xcodebuild -scheme "$PRODUCT_NAME" -derivedDataPath .build -destination 'generic/platform=watchOS';
- name: Build visionOS
    run: xcodebuild -scheme "$PRODUCT_NAME" -derivedDataPath .build -destination 'generic/platform=xrOS'