<?php

declare(strict_types=1);

namespace App\Stenope\Provider\Factory;

use App\Stenope\Provider\ReadmeDirProvider;
use Stenope\Bundle\Provider\ContentProviderInterface;
use Stenope\Bundle\Provider\Factory\ContentProviderFactoryInterface;

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
