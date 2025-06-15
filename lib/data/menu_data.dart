import '../models/menu_item.dart';

final List<MenuItem> menuData = [
  // Entrées marocaines
  MenuItem(
    id: 'e1',
    name: 'Harira',
    description:
        'Soupe traditionnelle marocaine à base de tomates, lentilles, pois chiches et coriandre.',
    image: 'assets/images/harira.jpeg',
    price: 5.0,
    category: 'Entrées marocaines',
    likes: 12,
    dislikes: 1,
    comments: [
      'Un vrai goût du Maroc !',
      'Délicieuse et parfumée.',
    ],
  ),
  MenuItem(
    id: 'e2',
    name: 'Briouates',
    description:
        'Feuilletés croustillants farcis à la viande hachée ou au fromage.',
    image: 'assets/images/briouates.jpeg',
    price: 6.0,
    category: 'Entrées marocaines',
    likes: 8,
    dislikes: 0,
    comments: [
      'Très croustillant, j’adore !',
    ],
  ),
  MenuItem(
    id: 'e3',
    name: 'Zaalouk',
    description: 'Salade d’aubergines et tomates épicée à l’huile d’olive.',
    image: 'assets/images/zaalouk.jpeg',
    price: 5.5,
    category: 'Entrées marocaines',
    likes: 10,
    dislikes: 0,
    comments: [
      'Goût authentique !',
    ],
  ),
  // Tajines et Couscous
  MenuItem(
    id: 'p1',
    name: 'Tajine de poulet aux olives',
    description:
        'Poulet mijoté avec olives, citron confit et épices marocaines.',
    image: 'assets/images/tajine_poulet.jpeg',
    price: 14.0,
    category: 'Tajines et Couscous',
    likes: 20,
    dislikes: 2,
    comments: [
      'Le tajine est délicieux !',
      'Parfaitement épicé.',
    ],
  ),
  MenuItem(
    id: 'p2',
    name: 'Couscous aux sept légumes',
    description:
        'Semoule fine servie avec un assortiment de légumes et viande.',
    image: 'assets/images/couscous.jpeg',
    price: 13.0,
    category: 'Tajines et Couscous',
    likes: 18,
    dislikes: 1,
    comments: [
      'Un classique, très copieux.',
    ],
  ),
  MenuItem(
    id: 'p3',
    name: 'Méchoui d’agneau',
    description: 'Agneau rôti à la marocaine, tendre et parfumé.',
    image: 'assets/images/mechoui.jpeg',
    price: 18.0,
    category: 'Tajines et Couscous',
    likes: 15,
    dislikes: 0,
    comments: [
      'Viande fondante, un régal !',
    ],
  ),
  // Douceurs marocaines
  MenuItem(
    id: 'd1',
    name: 'Cornes de gazelle',
    description: 'Pâtisseries fines aux amandes et fleur d’oranger.',
    image: 'assets/images/cornes_gazelle.jpeg',
    price: 4.0,
    category: 'Douceurs marocaines',
    likes: 9,
    dislikes: 0,
    comments: [
      'Très bon avec le thé !',
    ],
  ),
  MenuItem(
    id: 'd2',
    name: 'Chebakia',
    description: 'Gâteau au miel et graines de sésame, spécialité du Ramadan.',
    image: 'assets/images/chebakia.jpeg',
    price: 4.0,
    category: 'Douceurs marocaines',
    likes: 7,
    dislikes: 0,
    comments: [
      'Goût sucré et parfumé.',
    ],
  ),
  // Boissons locales
  MenuItem(
    id: 'b1',
    name: 'Thé à la menthe',
    description:
        'Thé vert infusé à la menthe fraîche, symbole de l’hospitalité marocaine.',
    image: 'assets/images/the_menthe.jpeg',
    price: 3.0,
    category: 'Boissons locales',
    likes: 16,
    dislikes: 0,
    comments: [
      'Rafraîchissant et authentique.',
    ],
  ),
  MenuItem(
    id: 'b2',
    name: 'Jus d’orange frais',
    description: 'Jus pressé à la minute, plein de vitamines.',
    image: 'assets/images/jus_orange.jpeg',
    price: 3.5,
    category: 'Boissons locales',
    likes: 11,
    dislikes: 0,
    comments: [
      'Très frais !',
    ],
  ),
];
