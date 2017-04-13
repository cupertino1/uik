﻿// Переменнная для получения структуры действующего дерева настроек
Перем ДеревоНастроек Экспорт;

// Переменнная для получения структуры действующего дерева настроек
Перем ДеревоНастроекПоУмолчанию Экспорт;

// Переменная для контроля закрытия формы через кнопки
Перем ЗакрытиеЧерезКнопки;

Процедура ПриОткрытии()
	
	НастройкиВФорме = ДеревоНастроек.Скопировать();

	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Данные = "НастройкиВФорме";
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.СоздатьКолонки();
	
	// установки оформления колонок
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["Код"].Ширина = 7;
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["Код"].ИзменениеРазмера = ИзменениеРазмераКолонки.НеИзменять;
	
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["ВключатьВОтчет"].Ширина = 9;
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["ВключатьВОтчет"].ИзменениеРазмера = ИзменениеРазмераКолонки.НеИзменять;
	
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["Существенность"].Ширина = 8;
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["Существенность"].ИзменениеРазмера = ИзменениеРазмераКолонки.НеИзменять;
	
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["МаксимальноеКоличество"].Ширина = 6;
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["МаксимальноеКоличество"].ИзменениеРазмера = ИзменениеРазмераКолонки.НеИзменять;
	
	// установки видимости и доступности колонок
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["Наименование"].ТолькоПросмотр = Истина;
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["Код"].ТолькоПросмотр = Истина;
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["ИмяОбластиДопСтроки"].Видимость = Ложь;
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["ТипСостава"].Видимость = Ложь;
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["ЗначениеЭлемента"].Видимость = Ложь;

	Если НЕ ЕстьРасширяемыеСтроки(НастройкиВФорме) Тогда
		ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["Существенность"].Видимость = Ложь;
		ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["МаксимальноеКоличество"].Видимость = Ложь;
	КонецЕсли;
	
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["ВключатьВОтчет"].Данные = "";
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["ВключатьВОтчет"].ДанныеФлажка = "ВключатьВОтчет";
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["ВключатьВОтчет"].РежимРедактирования = РежимРедактированияКолонки.Непосредственно;
	ЭлементыФормы.ТабличноеПолеДеревоНастроек.Колонки["ВключатьВОтчет"].ГоризонтальноеПоложениеВКолонке = ГоризонтальноеПоложение.Центр;
	
КонецПроцедуры

Процедура ТабличноеПолеДеревоНастроекПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	// Строки, допускающие определение состава выводятся жирным шрифтом
	Если НЕ ПустаяСтрока(ДанныеСтроки.ТипСостава) Тогда
		ОформлениеСтроки.Ячейки.Наименование.Шрифт = Новый Шрифт(ОформлениеСтроки.Ячейки.Наименование.Шрифт, , , Истина);
	КонецЕсли;
	
	// Для родительских строк отключается возможность ввода значений существенности и максимального количества
	Если ДанныеСтроки.Строки.Количество() > 0 Тогда
		ОформлениеСтроки.Ячейки.Существенность.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.Существенность.Видимость = Ложь;
		ОформлениеСтроки.Ячейки.МаксимальноеКоличество.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.МаксимальноеКоличество.Видимость = Ложь;
	КонецЕсли;
	
	// Если не указана область доп.строки, то не отображаем флажок включения в отчет
	// в противном случае не отображаем значения существенности и максимального количества для нерасширяемых строк
	Если ПустаяСтрока(ДанныеСтроки.ИмяОбластиДопСтроки) Тогда
		ОформлениеСтроки.Ячейки.ВключатьВОтчет.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.ВключатьВОтчет.Видимость = Ложь;
	ИначеЕсли ПустаяСтрока(ДанныеСтроки.ТипСостава) Тогда
		ОформлениеСтроки.Ячейки.Существенность.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.Существенность.Видимость = Ложь;
		ОформлениеСтроки.Ячейки.МаксимальноеКоличество.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.МаксимальноеКоличество.Видимость = Ложь;
	КонецЕсли;
	
	// Для строк со ссылками на значение не отображаем флажок включения, значения существенности и максимального количества
	Если ЗначениеЗаполнено(ДанныеСтроки.ЗначениеЭлемента) Тогда 
		ОформлениеСтроки.Ячейки.ВключатьВОтчет.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.ВключатьВОтчет.Видимость = Ложь;
		ОформлениеСтроки.Ячейки.Существенность.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.Существенность.Видимость = Ложь;
		ОформлениеСтроки.Ячейки.МаксимальноеКоличество.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.МаксимальноеКоличество.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСохранить(Кнопка)
	
	ЗакрытиеЧерезКнопки = Истина;
	
	Если Модифицированность Тогда
		ЭтаФорма.Закрыть(НастройкиВФорме);
	Иначе
		ЭтаФорма.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	ЗакрытиеЧерезКнопки = Истина;
	
	Если Модифицированность Тогда
		ТекстВопроса = "Состав дополнительных строк был изменен. Сохранить изменения?";
		ОтветПользователя = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		Если ОтветПользователя = КодВозвратаДиалога.Да Тогда
			ЭтаФорма.Закрыть(НастройкиВФорме);
		ИначеЕсли ОтветПользователя = КодВозвратаДиалога.Нет Тогда
			ЭтаФорма.Закрыть();
		Иначе
			// закрывать форму не нужно
		КонецЕсли;
		
	Иначе
		ЭтаФорма.Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗакрытиеЧерезКнопки И Модифицированность Тогда
		ТекстВопроса = "Состав дополнительных строк был изменен. Сохранить изменения?";
		ОтветПользователя = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		Если ОтветПользователя = КодВозвратаДиалога.Да Тогда
			Отказ = Истина;
			ЭтаФорма.Закрыть(НастройкиВФорме);
		ИначеЕсли ОтветПользователя = КодВозвратаДиалога.Нет Тогда
			// закрываем форму в обычном порядке
		Иначе
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеДеревоНастроекПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель)

	Отказ = Истина;
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Родитель.ЗначениеЭлемента) Тогда
		// Можно добавить элемент к родителю верхнего уровня
		УзелРодителя = Родитель.Родитель;
	Иначе
		УзелРодителя = Родитель;
	КонецЕсли;
	
	Если ПустаяСтрока(УзелРодителя.ТипСостава) Тогда
		Возврат;
	КонецЕсли;
	
	Если Найти(УзелРодителя.ТипСостава, "Справочник.") = 1 Тогда
		ПозицияРазделителя = Найти(УзелРодителя.ТипСостава, ".");
		ИмяСправочника = Сред(УзелРодителя.ТипСостава, ПозицияРазделителя + 1);
		
		ФормаВыбора = Справочники[ИмяСправочника].ПолучитьФормуВыбора(, ЭтаФорма, );
		
		РезультатВыбора = ФормаВыбора.ОткрытьМодально();
		
		Если РезультатВыбора <> Неопределено Тогда
			// Выбор групп не предусмотрен в этой версии формы
			Если РезультатВыбора.ЭтоГруппа Тогда
				Сообщить("Выбор групп из справочников не предусмотрен", СтатусСообщения.Внимание);
				Возврат;
			КонецЕсли;
			
			// Проверяем, не дублируется ли значение в ветви дерева
			Если УзелРодителя.Строки.Найти(РезультатВыбора, "ЗначениеЭлемента") <> Неопределено Тогда
				Сообщить("Элемент " + РезультатВыбора.Наименование + " уже включен в состав строки " + УзелРодителя.Наименование + ?(ПустаяСтрока(УзелРодителя.Код), "", " (" + УзелРодителя.Код + ")"), СтатусСообщения.Внимание);
				Возврат;
			КонецЕсли;
			
			НоваяСтрока = УзелРодителя.Строки.Добавить();
			НоваяСтрока.Наименование = РезультатВыбора.Наименование;
			НоваяСтрока.ЗначениеЭлемента = РезультатВыбора;
			
			Элемент.ТекущаяСтрока = НоваяСтрока;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеДеревоНастроекПередУдалением(Элемент, Отказ)
	
	Если Не ЗначениеЗаполнено(Элемент.ТекущиеДанные.Родитель) ИЛИ ПустаяСтрока(Элемент.ТекущиеДанные.Родитель.ТипСостава) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыФлажкиУстановить(Кнопка)
	ПрисвоитьЗначениеФлажкам(НастройкиВФорме, Истина);
	Модифицированность = Истина;
КонецПроцедуры

Процедура ДействияФормыОтметкиСнять(Кнопка)
	ПрисвоитьЗначениеФлажкам(НастройкиВФорме, Ложь);
	Модифицированность = Истина;
КонецПроцедуры

// <Описание процедуры>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
Процедура ПрисвоитьЗначениеФлажкам(ВетвьДерева, ЗначениеФлажка)

	Для Каждого СтрокаДерева Из ВетвьДерева.Строки Цикл
		СтрокаДерева.ВключатьВОтчет = ЗначениеФлажка;
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			ПрисвоитьЗначениеФлажкам(СтрокаДерева, ЗначениеФлажка);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ПрисвоитьЗначениеФлажкам()

// <Описание функции>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
Функция ЕстьРасширяемыеСтроки(ВетвьДерева)

	Для Каждого СтрокаДерева Из ВетвьДерева.Строки Цикл
		Если НЕ ПустаяСтрока(СтрокаДерева.ТипСостава) Тогда
			Возврат Истина;
		Иначе
			Если СтрокаДерева.Строки.Количество() > 0 Тогда
				Если ЕстьРасширяемыеСтроки(СтрокаДерева) Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;

КонецФункции // ЕстьРасширяемыеСтроки()

Процедура ДействияФормыДействиеСправка(Кнопка)
	ОткрытьСправкуФормы();
КонецПроцедуры

Процедура ДействияФормыСбросить(Кнопка)
	Если ДеревоНастроекПоУмолчанию <> Неопределено Тогда
		НастройкиВФорме = ДеревоНастроекПоУмолчанию.Скопировать();
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////////////////////////
// Операторы инициализации формы

ЗакрытиеЧерезКнопки = Ложь;