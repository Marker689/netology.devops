# Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."

## Задача 1

Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

```
Ответ:
Апаратная виртуализация - виртуализация на уровне железа. Гипервизоры на таком уровне сами заменяют собой ОС.

Паравиртуализация.
Виртуализация на уровне ОС. К примеру KVM.

Виртуализация уровня операционной системы.
Почти тоже самое за исключением того факта что мы должны использовать ядро такое же как в хостовой ОС.

Полная виртуализация отличается от паравиртуализации, потому что при полной виртуализации немодифицированная ОС работает полностью изолированно. С другой стороны, при паравиртуализации виртуальная машина не изолирует ОС полностью, а модифицирует ее, чтобы сделать ее совместимой с определенными API.

Паравиртуализация, некоторые компоненты, например сетевые или дисковые (и другие) устройства могут быть доступны напрямую через вызовы наружу виртуальной машины (с некоторыми оговорками). Для работы с паравиртуализированным оборудованием нужны отдельные драйверы и программные вызовы.

Паравиртуализация в общем случае работает быстрее, так как нет накладных расходов на ненужную эмуляцию.

В основном они отличаются тем, что при полной виртуализации немодифицированная ОС не осведомлена о виртуализации и использует двоичную трансляцию для перехвата вызовов ОС во время выполнения. И наоборот, в паравиртуализация, гипервызовы используются вместо невиртуализируемых инструкций ОС, и весь этот процесс происходит во время компиляции, где обрабатываются эти инструкции.
```

## Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:
- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:
- Высоконагруженная база данных, чувствительная к отказу.
- Различные web-приложения.
- Windows системы для использования бухгалтерским отделом.
- Системы, выполняющие высокопроизводительные расчеты на GPU.

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

```
Физические сервера: Высоконагруженная база данных, чувствительная к отказу. Системы, выполняющие высокопроизводительные расчеты на GPU.
Прямой доступ к железу отсутвие каких либо программных тормозов.

Паравиртуализация: Windows системы для использования бухгалтерским отделом.
Просто и удобно, есть рычаги управления.
Паравиртуализация в общем случае работает быстрее, так как нет накладных расходов на ненужную эмуляцию.

Виртуализация уровня ОС: Различные web-приложения. 
Минимум накладных расходов.
```

## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий. 

> VMWare, имеет все необходимые функции 

2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин. 

> Proxmox, на мой взгляд, лучший Open source гипервизор, имеющий множество фишек поверх KVM.

3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры. 

> Думаю Hyper-V Server — специально для тех, кто не хочет платить за систему аппаратной виртуализации. Никаких ограничений на процедуры и при этом он абсолютно бесплатный, полная совместимость с Win.

4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux. 

> Однозначно KVM. KVM является нативным для большинства современных ядер Linux. Это дает преимущество в производительности по сравнению с другими системами виртуализации. Как частный случай KVM - Proxmox

## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

```
Требуется целый набор специалистов различного профиля под каждую среду, данный способ виртуализации инфраструктуры является дорогостоящим и неэффективным в долгосрочной перспективе, поскольку, по мере развития технологий, компании стремятся обеспечить легкость в управлении, совместимость различных систем и масштабируемость инфраструктуры. 
```

---