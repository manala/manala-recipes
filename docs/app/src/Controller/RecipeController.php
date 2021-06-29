<?php

declare(strict_types=1);

namespace App\Controller;

use App\Model\Recipe;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;

/**
 * @Route(path="/recipes", name="recipes_")
 */
class RecipeController extends AbstractController
{
    /**
     * @Route(path="/{recipe}", name="show", requirements={"recipe"=".+"})
     */
    public function show(Recipe $recipe)
    {
        return $this->render('recipes/show.html.twig', [
           'recipe' => $recipe,
        ]);
    }
}
