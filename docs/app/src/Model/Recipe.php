<?php

declare(strict_types=1);

namespace App\Model;

use Stenope\Bundle\TableOfContent\TableOfContent;

class Recipe
{
    public string $title;
    public string $slug;
    public string $content;
    public TableOfContent $tableOfContent;
    public \DateTimeInterface $created;
    public \DateTimeInterface $lastModified;
}
