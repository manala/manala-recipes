<?php

declare(strict_types=1);

namespace App\Controller;

use App\Model\Migration;
use App\Model\Recipe;
use Stenope\Bundle\ContentManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;

#[Route(path: '/recipes', name: 'recipes_')]
class RecipeController extends AbstractController
{
    private ContentManagerInterface $contentManager;

    public function __construct(ContentManagerInterface $contentManager)
    {
        $this->contentManager = $contentManager;
    }

    #[Route(path: '/{recipe}', name: 'show', requirements: ['recipe' => '.+'])]
    public function show(Recipe $recipe)
    {
        return $this->render('recipes/show.html.twig', [
            'recipe' => $recipe,
            'migrations' => $this->contentManager->getContents(Migration::class, null, ['recipe' => $recipe->slug]),
        ]);
    }
}
