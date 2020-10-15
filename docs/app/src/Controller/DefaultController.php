<?php

namespace App\Controller;

use App\Model\DefaultPage;
use Content\ContentManager;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;

class DefaultController extends AbstractController
{
    private ContentManager $contentManager;

    public function __construct(ContentManager $contentManager)
    {
        $this->contentManager = $contentManager;
    }

    /**
     * @Route(path="/", name="index")
     */
    public function index()
    {
        /** @var DefaultPage $page */
        $page = $this->contentManager->getContent(DefaultPage::class, 'index');

        return $this->render('index.html.twig', [
           'page' => $page,
        ]);
    }
}
