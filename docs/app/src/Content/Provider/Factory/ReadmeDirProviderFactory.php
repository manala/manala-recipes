<?php

namespace App\Content\Provider\Factory;

use App\Content\Provider\ReadmeDirProvider;
use Content\Provider\ContentProviderInterface;
use Content\Provider\Factory\ContentProviderFactoryInterface;

class ReadmeDirProviderFactory implements ContentProviderFactoryInterface
{
    public const TYPE = 'readme_dir';

    public function create(string $type, array $config): ContentProviderInterface
    {
        return new ReadmeDirProvider(
            $config['class'],
            $config['path'],
            $config['excludes'] ?? [],
        );
    }

    public function supports(string $type, array $config): bool
    {
        return self::TYPE === $type;
    }
}
