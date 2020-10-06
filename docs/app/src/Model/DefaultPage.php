<?php

namespace App\Model;

class DefaultPage
{
    public string $title;
    public string $slug;
    public string $content;
    public \DateTimeInterface $created;
    public \DateTimeInterface $lastModified;
}
