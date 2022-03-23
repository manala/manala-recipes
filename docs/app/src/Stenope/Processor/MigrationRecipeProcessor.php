<?php

declare(strict_types=1);

namespace App\Stenope\Processor;

use App\Model\Migration;
use Stenope\Bundle\Behaviour\ProcessorInterface;
use Stenope\Bundle\Content;

/**
 * Get the recipe iD from migration path
 */
class MigrationRecipeProcessor implements ProcessorInterface
{
    private string $property;

    public function __construct(string $property = 'recipe')
    {
        $this->property = $property;
    }

    public function __invoke(array &$data, Content $content): void
    {
        if ($content->getType() !== Migration::class) {
            return;
        }

        $data[$this->property] = \dirname($content->getSlug());
    }
}
