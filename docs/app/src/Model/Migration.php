<?php

declare(strict_types=1);

namespace App\Model;

use App\Stenope\Processor\MigrationRecipeProcessor;
use Stenope\Bundle\TableOfContent\TableOfContent;

class Migration
{
    public string $title;
    public string $slug;
    public string $content;
    public TableOfContent $tableOfContent;
    public \DateTimeInterface $created;
    public \DateTimeInterface $lastModified;

    /** @see MigrationRecipeProcessor */
    public string $recipe;
}
