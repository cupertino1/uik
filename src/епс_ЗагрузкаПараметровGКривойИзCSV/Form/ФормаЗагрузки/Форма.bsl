﻿&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Заголовок = "Выберите файл";
	
	Если ДиалогВыбора.Выбрать() Тогда
		Объект.ИмяФайла = ДиалогВыбора.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры
//--------------------------------------------------------------------------------------------------------------
&НаСервере
Процедура ПрочитатьФайлНаСервере()
	ТаблицаЗн = Новый ТаблицаЗначений;
	
	ЗагружаемыйФайл = Новый ТекстовыйДокумент;
	ЗагружаемыйФайл.Прочитать(Объект.ИмяФайла);
	
	//шапка по умолчанию 3 строка, из первой строки делаем колонки таблицы
	Шапка = ЗагружаемыйФайл.ПолучитьСтроку(3);
	
	//раскладываем строку в массив
	МассивКолонок = РазложитьСтрокуВМассивПодстрок(Шапка, Объект.Разделитель);
	
	//генерируем колонки	
	Для Каждого ИмяКолонки Из МассивКолонок Цикл 		
		ИмяБезПробелов = ВРег(СтрЗаменить(ИмяКолонки," ","")); // убираем из имени колонок пробелы
		
		//////TRADEDATE	TRADETIME	PARAMS_TYPE	BETA0	BETA1	BETA2	TAU	G1	G2	G3	PARAMS_TITLE
		Если ИмяБезПробелов = "TRADEDATE" Тогда
			КвалификаторыДаты = Новый КвалификаторыДаты(ЧастиДаты.Дата);
			ТипЗн = Новый ОписаниеТипов("Дата", КвалификаторыДаты); 		
		ИначеЕсли ИмяБезПробелов = "B1" или ИмяБезПробелов = "B2" или ИмяБезПробелов = "B3" или
				  ИмяБезПробелов = "T1" или 
				  ИмяБезПробелов = "G1" или ИмяБезПробелов = "G2" или ИмяБезПробелов = "G3" или
				  ИмяБезПробелов = "G4" или ИмяБезПробелов = "G5" или ИмяБезПробелов = "G6" или
				  ИмяБезПробелов = "G7" или ИмяБезПробелов = "G8" или ИмяБезПробелов = "G9"
				  	Тогда
			КвалификаторыЧисла = Новый КвалификаторыЧисла(25, 6, ДопустимыйЗнак.Любой);
			ТипЗн = Новый ОписаниеТипов("Число", КвалификаторыЧисла);
		//ИначеЕсли ИмяБезПробелов = "PARAMS_TYPE" или ИмяБезПробелов = "PARAMS_TITLE" или ИмяБезПробелов = "TRADETIME" Тогда
		//	ТипЗн = Новый ОписаниеТипов("Строка");
		КонецЕсли; 		
		ТаблицаЗн.Колонки.Добавить(ИмяБезПробелов, ТипЗн, ИмяКолонки);
		
		//ТаблицаЗн.Колонки.Добавить(ИмяБезПробелов, , ИмяКолонки); 
	КонецЦикла;
	                    
	Для НомерСтроки = 4 по ЗагружаемыйФайл.КоличествоСтрок() Цикл		
		// получить строку файла с указанным номером и преобразуем её в массив
		Строка = ЗагружаемыйФайл.ПолучитьСтроку(НомерСтроки);
		Если ПустаяСтрока(Строка) Тогда
			Прервать;
		КонецЕсли;	
		МассивКолонок = РазложитьСтрокуВМассивПодстрок(Строка,Объект.Разделитель);
		НоваяСтрока = ТаблицаЗн.Добавить();  		

		Для НомерКолонки = 1 по МассивКолонок.Количество() Цикл 
			//заполняем строку значениями
			ТекущееЗначение = МассивКолонок[НомерКолонки-1];
			ИмяКолонки = ТаблицаЗн.Колонки[НомерКолонки-1].Имя; 		
			
			Если ИмяКолонки = "TRADEDATE" Тогда
				ТекущееЗначение = НачалоДня(Дата(ТекущееЗначение + " 0:00:00") - 1);
			КонецЕсли;	
			НоваяСтрока[ИмяКолонки] = ТекущееЗначение;
			
		КонецЦикла;   		
		
	КонецЦикла; 
	
	
	МассивПараметровОтбора = Новый Массив;
	//МассивПараметровОтбора.Добавить(Новый Структура("Ключ, ВидСравнения, Значение", "PARAMS_TITLE", ВидСравнения.Содержит, "На конец предыдущего дня"));
    //////Если НЕ епс_БиблиотекаПолезныхПроцедурИФункций.ЕслиДатаПустая(Объект.ДатаОценкиНачальная) Тогда
    //////	МассивПараметровОтбора.Добавить(Новый Структура("Ключ, ВидСравнения, Значение", "TRADEDATE", ВидСравнения.БольшеИлиРавно, НачалоДня(Объект.ДатаОценкиНачальная)));
    //////КонецЕсли;	
    //////Если НЕ епс_БиблиотекаПолезныхПроцедурИФункций.ЕслиДатаПустая(Объект.ДатаОценкиКонечная) Тогда
    //////	МассивПараметровОтбора.Добавить(Новый Структура("Ключ, ВидСравнения, Значение", "TRADEDATE", ВидСравнения.МеньшеИлиРавно, КонецДня(Объект.ДатаОценкиКонечная)));
    //////КонецЕсли;
    //////епс_БиблиотекаПолезныхПроцедурИФункций.ОтборВТаблицеЗначений(ТаблицаЗн, МассивПараметровОтбора);
    //////

	// Записать ТаблицаЗн в регистр епс_ПараметрыКривойБескупоннойДоходности
	ЗаписатьИтоговуюТаблицуВРегистр(ТаблицаЗн);
КонецПроцедуры
//--------------------------------------------------------------------------------------------------------------
&НаСервере
Процедура ЗаписатьИтоговуюТаблицуВРегистр(ИтоговаяТаблица)
	НовыйНабор = РегистрыСведений.епс_ПараметрыКривойБескупоннойДоходности.СоздатьНаборЗаписей();		
	Для каждого Запись Из ИтоговаяТаблица Цикл 
		
		НовыйНабор.Отбор.Период.Использование = Истина;
		НовыйНабор.Отбор.Период.ВидСравнения = ВидСравнения.Равно;
		НовыйНабор.Отбор.Период.Значение = Запись.TRADEDATE;
		
		НовыйНабор.Очистить();
		
		НоваяЗапись = НовыйНабор.Добавить();
		                            
		НоваяЗапись.beta0 = Запись.B1;
		НоваяЗапись.beta1 = Запись.B2;
		НоваяЗапись.beta2 = Запись.B3;
		
		НоваяЗапись.tau = Запись.T1;
		
		НоваяЗапись.g1 = Запись.G1;
		НоваяЗапись.g2 = Запись.G2;
		НоваяЗапись.g3 = Запись.G3;
		НоваяЗапись.g4 = Запись.G4;
		НоваяЗапись.g5 = Запись.G5;
		НоваяЗапись.g6 = Запись.G6;
		НоваяЗапись.g7 = Запись.G7;
		НоваяЗапись.g8 = Запись.G8;
		НоваяЗапись.g9 = Запись.G9;
		
		НоваяЗапись.Период = Запись.TRADEDATE; 
		
		НовыйНабор.Записать();  
	КонецЦикла;
КонецПроцедуры
//--------------------------------------------------------------------------------------------------------------
Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ";")   Экспорт
	Если Разделитель = "" Тогда
		Разделитель = ";";
	КонецЕсли;
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока Истина Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = СокрЛ(Сред(Стр,Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока Истина Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = Сред(Стр,Поз+ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции
//--------------------------------------------------------------------------------------------------------------
&НаКлиенте
Процедура ПрочитатьФайл(Команда)
	ПрочитатьФайлНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	 Объект.ИмяФайла = ХранилищеСистемныхНастроек.Загрузить("ПутьКФайлуGКривой");
	 Объект.Разделитель = ХранилищеСистемныхНастроек.Загрузить("РазделительВФайлеGКривой");
	 Объект.ДатаОценкиКонечная = ХранилищеСистемныхНастроек.Загрузить("ДатаОценкиКонечнаяGКривой");
	 Объект.ДатаОценкиНачальная = ХранилищеСистемныхНастроек.Загрузить("ДатаОценкиНачальнаяGКривой");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	ХранилищеСистемныхНастроек.Сохранить("ПутьКФайлуGКривой",, Объект.ИмяФайла);
	ХранилищеСистемныхНастроек.Сохранить("РазделительВФайлеGКривой",, Объект.Разделитель);
	ХранилищеСистемныхНастроек.Сохранить("ДатаОценкиКонечнаяGКривой",, Объект.ДатаОценкиКонечная);
	ХранилищеСистемныхНастроек.Сохранить("ДатаОценкиНачальнаяGКривой",, Объект.ДатаОценкиНачальная);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ПриЗакрытииНаСервере();
КонецПроцедуры
