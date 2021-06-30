<?php

declare(strict_types=1);

namespace App\Model;

class DefaultPage
{
    public string $title;
    public string $slug;
    public string $content;
    public \DateTimeInterface $created;
    public \DateTimeInterface $lastModified;
}
