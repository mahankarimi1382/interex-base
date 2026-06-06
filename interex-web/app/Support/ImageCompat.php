<?php

namespace App\Support;

use Intervention\Image\Drivers\Gd\Driver;
use Intervention\Image\Encoders\AvifEncoder;
use Intervention\Image\Encoders\FileExtensionEncoder;
use Intervention\Image\Encoders\GifEncoder;
use Intervention\Image\Encoders\JpegEncoder;
use Intervention\Image\Encoders\PngEncoder;
use Intervention\Image\Encoders\WebpEncoder;
use Intervention\Image\ImageManager;
use Intervention\Image\Interfaces\EncodedImageInterface;
use Intervention\Image\Interfaces\ImageInterface;

/**
 * Backwards-compatible wrapper that exposes the Intervention Image v2 facade API
 * (make/orientate/resize/fit/encode/save/width/height) on top of Intervention
 * Image v4. This lets the existing image pipeline keep working unchanged after
 * the package was upgraded to v4 (which dropped the v2 facade and ServiceProvider).
 */
class ImageCompat
{
    protected ImageInterface $image;

    public function __construct(ImageInterface $image)
    {
        $this->image = $image;
    }

    /**
     * Create a new instance from a path, binary string, resource or UploadedFile.
     *
     * @param  mixed  $source
     */
    public static function make($source): self
    {
        $manager = new ImageManager(new Driver);

        // v4 ImageManager exposes read()/decode() depending on the release;
        // use whichever is available so the shim works across 4.x versions.
        $image = method_exists($manager, 'read')
            ? $manager->read($source)
            : $manager->decode($source);

        return new self($image);
    }

    /**
     * v2 orientate() -> v4 orient() (applies EXIF orientation).
     */
    public function orientate(): self
    {
        $this->image->orient();

        return $this;
    }

    public function width(): int
    {
        return $this->image->width();
    }

    public function height(): int
    {
        return $this->image->height();
    }

    /**
     * v2 resize($w, $h, $callback). When a callback is supplied the v2 code uses
     * it only to keep the aspect ratio, which maps to v4's scale(); without a
     * callback it maps to an exact resize().
     *
     * @param  int|null  $width
     * @param  int|null  $height
     * @param  callable|null  $callback
     */
    public function resize($width = null, $height = null, $callback = null): self
    {
        if ($callback !== null) {
            // Run the legacy constraint callback against a no-op stub so the
            // existing closures ($constraint->aspectRatio()) don't error.
            $callback(new class
            {
                public function aspectRatio() {}

                public function upsize() {}
            });

            $this->image->scale(
                $width !== null ? (int) $width : null,
                $height !== null ? (int) $height : null,
            );

            return $this;
        }

        $this->image->resize(
            $width !== null ? (int) $width : null,
            $height !== null ? (int) $height : null,
        );

        return $this;
    }

    /**
     * v2 fit($w, $h, $callback, $position) -> v4 cover($w, $h, $position).
     *
     * @param  int  $width
     * @param  int|null  $height
     * @param  callable|null  $callback
     * @param  string  $position
     */
    public function fit($width, $height = null, $callback = null, $position = 'center'): self
    {
        $this->image->cover(
            (int) $width,
            (int) ($height ?? $width),
            $position ?: 'center',
        );

        return $this;
    }

    /**
     * v2 encode($format, $quality) -> v4 encode(EncoderInterface). Returns the v4
     * EncodedImage, which is stringable (usable as Storage::put contents) and
     * exposes save($path), preserving the v2 chaining behaviour.
     *
     * @param  string|null  $format
     * @param  int  $quality
     */
    public function encode($format = null, $quality = 90): EncodedImageInterface
    {
        $extension = strtolower((string) $format);

        $encoder = match ($extension) {
            'jpg', 'jpeg' => new JpegEncoder(quality: (int) $quality),
            'webp' => new WebpEncoder(quality: (int) $quality),
            'avif' => new AvifEncoder(quality: (int) $quality),
            'png' => new PngEncoder,
            'gif' => new GifEncoder,
            default => $extension !== ''
                ? new FileExtensionEncoder($extension)
                : new FileExtensionEncoder,
        };

        return $this->image->encode($encoder);
    }

    /**
     * v2 save($path) -> v4 save($path).
     *
     * @param  string|null  $path
     */
    public function save($path = null, $quality = 90): self
    {
        $this->image->save($path);

        return $this;
    }

    /**
     * Proxy any other calls to the underlying v4 image instance.
     *
     * @param  string  $name
     * @param  array  $arguments
     */
    public function __call($name, $arguments)
    {
        $result = $this->image->{$name}(...$arguments);

        return $result instanceof ImageInterface ? $this : $result;
    }
}
