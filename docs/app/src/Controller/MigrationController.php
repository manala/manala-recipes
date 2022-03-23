<?php

declare(strict_types=1);

namespace App\Controller;

use App\Model\Migration;
use App\Model\Recipe;
use Stenope\Bundle\ContentManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;

/**
 * @Route(path="/migrations", name="migrations_")
 */
class MigrationController extends AbstractController
{
    private ContentManagerInterface $contentManager;

    public function __construct(ContentManagerInterface $contentManager)
    {
        $this->contentManager = $contentManager;
    }

    /**
     * @Route(path="/{migration}", name="show", requirements={"migration"=".+"})
     */
    public function show(Migration $migration)
    {
        return $this->render('migrations/show.html.twig', [
           'recipe' => $this->contentManager->getContent(Recipe::class, $migration->recipe),
           'migration' => $migration,
        ]);
    }
}
