<?php

namespace App\Stenope\Provider;

use Stenope\Bundle\Content;
use Stenope\Bundle\Provider\ContentProviderInterface;
use Stenope\Bundle\Provider\LocalFilesystemProvider;

/**
 * Extract contents from directories with a README.md file inside.
 */
class ReadmeDirProvider implements ContentProviderInterface
{
    private string $supportedClass;
    private LocalFilesystemProvider $localProvider;

    public function __construct(
        string $supportedClass,
        string $path,
        array $excludes = []
    ) {
        $this->supportedClass = $supportedClass;
        $this->localProvider = new LocalFilesystemProvider($supportedClass, $path, 1, $excludes, ['*/README.md']);
    }

    public function listContents(): iterable
    {
        foreach ($this->localProvider->listContents() as $content) {
            yield $this->fixupContent($content);
        }
    }

    public function getContent(string $slug): ?Content
    {
        if (!str_ends_with($slug, '/README')) {
            $slug = rtrim($slug, '/') . '/README';
        }

        if (!$content = $this->localProvider->getContent($slug)) {
            return null;
        }

        return $this->fixupContent($content);
    }

    private function fixupContent(Content $content): Content
    {
        return new Content(
            str_replace('/README', '', $content->getSlug()),
            $content->getRawContent(),
            $content->getFormat(),
            $content->getLastModified(),
            $content->getCreatedAt(),
        );
    }

    public function supports(string $className): bool
    {
        return $this->supportedClass === $className;
    }
}
