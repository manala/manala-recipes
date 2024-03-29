<?php

declare(strict_types=1);

namespace App\Stenope\Processor;

use App\Model\Recipe;
use Stenope\Bundle\Behaviour\ProcessorInterface;
use Stenope\Bundle\Content;
use Symfony\Component\DomCrawler\Crawler;

/**
 * Converts links supposed to be referencing a file available on Github, inside a Recipe.
 */
class GithubLinksProcessors implements ProcessorInterface
{
    private string $githubRawContentUrl;
    private string $property;

    public function __construct(string $githubContentUrl, string $property = 'content')
    {
        $this->githubRawContentUrl = $githubContentUrl;
        $this->property = $property;
    }

    public function __invoke(array &$data, Content $content): void
    {
        if ($content->getType() !== Recipe::class) {
            return;
        }

        $crawler = new Crawler($data[$this->property]);

        try {
            $crawler->html();
        } catch (\Exception $e) {
            // Content is not valid HTML.
            return;
        }

        $crawler = new Crawler($data[$this->property]);

        // Detect links starting with "./", susceptible to be pointing to a Github resource:
        foreach ($crawler->filter('a[href^="./"]') as $link) {
            $this->processLink($link, $content);
        }

        $data[$this->property] = $crawler->html();
    }

    private function processLink(\DOMElement $link, Content $content): void
    {
        $link->setAttribute('href', sprintf(
            '%s/%s/%s',
            rtrim($this->githubRawContentUrl, '/'),
            $content->getSlug(),
            substr($link->getAttribute('href'), 2),
        ));
    }
}
