---
title: Acknowledgements
description: Thanks and attributions related to the projects and concepts that inspired the Marten web framework.
---

This section lists and acknowledges the various projects that inspired the Marten web framework, as well as notable contributions.

## Inspirations

The Marten web framework implements a set of ideas and APIs that are inspired by the awesome work that was put into two particular frameworks: [Django](https://www.djangoproject.com/) and [Ruby on Rails](https://rubyonrails.org/). It can be easy to take for granted what these frameworks provide, and we should not forget to give credit where credit is due.

### Django

The Marten web framework takes a lot from [Django](https://www.djangoproject.com/) - its biggest source of inspiration:

* The [Model](../models-and-databases)-[Handler](../handlers-and-http)-[Template](../templates) triptych is Marten's vision of the Model-View-Template (MVT) pattern provided by Django
* The [auto-generated migrations](../models-and-databases/migrations) mechanism is inspired by a similar mechanism within Django
* [Generic handlers](../handlers-and-http/generic-handlers) are inspired by Django's generic class-based views
* The template syntax is inspired by Django's templating language
* The concept of [apps](../development/applications) and projects is inherited from Django as well

Needless to say that this is a non-exhaustive list.

### Ruby on Rails

The Marten web framework is also inspired by [Ruby on Rails](https://rubyonrails.org/) in some aspects. Among those we can mention:

* The [generic validation DSL](../models-and-databases/validations)
* Most [model callbacks](../models-and-databases/callbacks)
* The idea of [message encryptors](pathname:///api/Marten/Core/Encryptor.html) and [message signers](pathname:///api/Marten/Core/Signer.html)

### But also...

* The exception page displayed while in [debug](../development/reference/settings#debug) mode is inspired by the [Exception Page](https://github.com/crystal-loot/exception_page) shard
* The way to [handle custom objects](../templates/introduction#using-custom-objects-in-contexts) in Marten templates is inspired by a similar mechanism within [Crinja](https://github.com/straight-shoota/crinja)

## Contributors

Thanks to all the [contributors](https://github.com/martenframework/marten/contributors) of the project!
