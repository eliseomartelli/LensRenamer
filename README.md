# LensRenamer

LensRenamer is a macOS app for batch-writing lens EXIF metadata to image files.
It was created out of necessity after purchasing a Leica camera and wanting to
embed accurate lens information (make, model, serial, focal length) into photo
files, especially for manual or vintage lenses that do not communicate
electronically with the camera.

## Why?

Leica and many other cameras do not always write complete lens metadata to
image files, especially when using manual or adapted lenses. This makes it
difficult to organize, search, or process photos by lens in photo management
software. LensRenamer solves this by letting you select a lens and quickly
apply its EXIF tags to any number of images.

## Features

- **Batch EXIF writing:** Select multiple images and write lens metadata in one
go.
- **Drag & drop:** Drop files onto the app to process them.
- **Custom lens database:** Store and manage your own lens collection.
- **Progress feedback:** See when files are being processed.

## How it works

LensRenamer uses [ExifTool](https://exiftool.org/) under the hood to write the
following tags:

- `LensMake`
- `LensModel`
- `FocalLength`
- `LensSerialNumber`

You can add lenses to your collection, select one, and then apply its
information to your photos.

## Requirements

- macOS (tested on Apple Silicon)
- ExifTool (bundled with the app)

## License

MIT License. See [LICENSE](LICENSE) for details.

