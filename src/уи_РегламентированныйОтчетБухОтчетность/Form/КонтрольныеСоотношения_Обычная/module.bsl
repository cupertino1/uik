﻿Перем РезультатыПроверки Экспорт; // Используется для передачи в форму таблицы значений с результатами проверки
Перем Макет Экспорт; // Ссылка на макет
Перем ФормаРодитель Экспорт; // Ссылка на форму из которой была открыта эта форма. Необходима для обращения к методам родительской формы

Процедура ПриОткрытии()
	ВывестиРезультатыПроверки();
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Если Макет = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ОтобразитьТолькоОшибочныеКС = Истина;
	
КонецПроцедуры

Процедура ОтобразитьТолькоОшибочныеКСПриИзменении(Элемент)
	ВывестиРезультатыПроверки();
КонецПроцедуры

// <Описание процедуры>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
Процедура ВывестиРезультатыПроверки()

	// Очищаем имеющееся поле
	Таб = ЭлементыФормы.ПолеТабличногоДокументаКС;
	Таб.Очистить();
	
	СекцияЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	
	Таб.Вывести(СекцияЗаголовок);
	
	СекцияСтрокаДанных1 = Макет.ПолучитьОбласть("СтрокаДанных1");
	ПорядковыйНомерСтроки = 1;
	
	Для Каждого СтрокаРезультатаПроверки Из РезультатыПроверки Цикл
		// пропускаем положительные проверки если должны отображаться только несоблюденные соотношения
		Если ОтобразитьТолькоОшибочныеКС И СтрокаРезультатаПроверки.РезультатПроверки Тогда
			Продолжить;
		КонецЕсли;
		
		СекцияСтрокаДанных1.Параметры.Номер = ПорядковыйНомерСтроки;
		СекцияСтрокаДанных1.Параметры.ПроверяемоеСоотношение = СтрокаРезультатаПроверки.ПроверяемоеСоотношение;
		
		Если СтрокаРезультатаПроверки.РезультатПроверки Тогда
			СекцияСтрокаДанных1.Параметры.РезультатПроверки = "Соотношение соблюдено";
		Иначе
			СекцияСтрокаДанных1.Параметры.РезультатПроверки = "Соотношение не соблюдено";
		КонецЕсли;
		
		СекцияСтрокаДанных1.Параметры.ОписаниеНарушения = СтрокаРезультатаПроверки.ОписаниеНарушения;
		
		Таб.Вывести(СекцияСтрокаДанных1);
		
		ПорядковыйНомерСтроки = ПорядковыйНомерСтроки + 1;
		
	КонецЦикла;
	
КонецПроцедуры // ВывестиРезультатыПроверки()

Процедура КоманднаяПанель1ПересчитатьОбновить(Кнопка)
	РезультатыПроверки = ФормаРодитель.ПолучитьРезультатыПроверкиСоотношенияПоказателей();
	ВывестиРезультатыПроверки();
	
КонецПроцедуры
